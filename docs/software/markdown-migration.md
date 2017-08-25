Migrating to Markdown
=====================

As part of the TWiki retirement (the read-only target date of Oct 1, 2017, with a shutdown date in 2018), we will need to convert the OSG Software and Release3 docs from TWiki syntax to [Markdown](https://guides.github.com/features/mastering-markdown/). The following document outlines the conversion process and conventions.

Choosing the git repository
---------------------------

First you will need to choose which git repoository you will be working with:

| If you are converting a document from... | Use this github repository... |
| :--------------------------------------- | :---------------------------- |
| SoftwareTeam | [technology](https://www.github.com/opensciencegrid/technology/) |
| Release3 | [docs](https://www.github.com/opensciencegrid/docs/) |

Once you've chosen the target repository for your document, move onto the next section and pick your conversion method.

Automatic TWiki conversion
--------------------------

!!! note
    If you are only archiving the documents, skip to this [section](#archiving-documents).

Choose one of the following methods for converting TWiki documents:

- Using our own [docker conversion image](#using-docker) (recommended)
- A combination of [pandoc](#using-pandoc) and mkdocs

### Using docker ###

The twiki-converter docker image can be used to preview the document tree via a [mkdocs](http://www.mkdocs.org/#getting-started) development server, archive TWiki documents, and convert documents to Markdown via [pandoc](http://pandoc.org/). The image is available on `osghost`, otherwise, follow the instructions [here](https://github.com/brianhlin/docker-twiki-converter) to build it locally. 

#### Requirements ####

To perform a document migration using docker, you will need the following tools and accounts:

- [Fork](https://help.github.com/articles/fork-a-repo/) and [clone](https://help.github.com/articles/cloning-a-repository/) the repository that you chose in the [above section](#choosing-the-git-repository)
- A host with a running docker service
- `sudo` or membership in the `docker` group

If you cannot install the above tools locally, they are available on `osghost`. Speak with Brian L for access.

#### Preparing the git repository ####

1. `cd` into your local git repository
3. Add `opensciencegrid/technology` as the upstream remote repository for merging upstream changes:

        :::console
        [user@client ~ ] $ git remote add upstream https://www.github.com/opensciencegrid/%RED%<REPOSITORY>%ENDCOLOR%.git

4. Create a branch for the document you plan to convert:

        :::console
        [user@client ~ ] $ git branch %RED%<BRANCH NAME>%ENDCOLOR% master

5. Change to the branch you just created

        :::console
        [user@client ~ ] $ git checkout %RED%<BRANCH NAME>%ENDCOLOR%

#### Previewing the document tree ####

When starting a twiki-converter docker container, it expects your local github repository to be mounted in `/source` so that any changes made to the repository are reflected in the mkdocs development server. To start a docker container based off of the twiki-converter docker image:

1. Create a container from the image with the following command:

        :::console
        [user@client ~ ] $ docker run -d -v %RED%<PATH TO LOCAL GITHUB REPO>%ENDCOLOR%:/source -p 8000 twiki
    The above command should return the container ID, which will be used in subsequent commands. 

    !!! note
        If the docker container exits immediately, remove the `-d` option for details. If you see permission denied errors, you may need to disable SELinux or put it in permissive mode.

2. To find the port that your development server is lisetning on, use the container ID (you should only need the first few chars of the ID) returned from the previous command:

        :::console
        [user@client ~ ] $ docker port %RED%<CONTAINER ID>%ENDCOLOR%

3. Access the development server in your browser via `http://osghost.chtc.wisc.edu:<PORT>` or `localhost:<PORT>` for containers run on `osghost` or locally, respectively. `osghost` has a restrictive firewall so if you have issues accessing your container from outside of the UW-Madison campus, use an SSH tunnel to map the `osghost` port to a local port.

#### Converting documents ####

The docker image contains a convenience script, `convert-twiki` for saving archives and converting them to Markdown. To run the script in a running container, run the following command:

```console
[user@client ~ ] $ docker exec %RED%<CONTAINER ID>%ENDCOLOR% convert-twiki %RED%<TWIKI URL>%ENDCOLOR%
```

Where %RED%<CONTAINER ID>%ENDCOLOR% is the docker container ID and %RED%<TWIKI URL>%ENDCOLOR% is the link to the TWiki document that you want to convert, e.g. [https://twiki.opensciencegrid.org/bin/view/SoftwareTeam/SoftwareDevelopmentProcess](https://twiki.opensciencegrid.org/bin/view/SoftwareTeam/SoftwareDevelopmentProcess). This will result in an archive of the twiki doc, `archive/SoftwareDevelopmentProcess`, in your local repo and a converted copy, `SoftwareDevelopmentProcess`, placed into the root of your local github repository. 

!!! warning
    If the above command does not complete quickly, it means that Pandoc is having an issue with a specific section of the document. See [Troubleshooting conversion](#troubleshooting-conversion) for next steps.

To see the converted document in your browser:

1. Rename, move the converted document into a folder in `docs/`.
    - Document file names should be lowercase, `-` delimited, and descriptive but concise, e.g. `markdown-migration.md` or `cutting-release.md`
    - It's not important to get the name/location correct on the first try as this can be discussed in the pull request
2. `sudo chown` the archived and converted documents to be owned by you
3. Add the document to the `pages:` section of `mkdocs.yml` in [title case](http://titlecase.com/), e.g. `- Migrating Documents to Markdown: 'software/markdown-migration.md'`
4. Refresh the document tree in your browser

Once you can view the converted document in your browser, move onto the [next section](#completing-the-conversion)

#### Troubleshooting conversion ####

Pandoc sometimes has issues converting documents and requires manual intervention by removing whichever section is causing issues in the conversion.

1. Copy the archive of the document into the root of your git repository
2. Kill the process in the docker container:

        :::console
        [user@client ~ ] $ docker exec %RED%<CONTAINER ID>%ENDCOLOR% pkill -9 pandoc

3. Remove a section from the copy of the archive to find the problematic section (recommendation: use a binary search strategy)
4. Run pandoc manually:

        :::console
        [user@client ~ ] $ docker exec %RED%<CONTAINER ID>%ENDCOLOR% pandoc -f twiki -t markdown_github %RED%<ARCHIVE COPY>%ENDCOLOR% > %RED%<MARKDOWN FILE>%ENDCOLOR%

5. Repeat steps 2-4 until you've narrowed down the problematic section
6. Manually convert the offending section

### Using pandoc ###

If you've already used the [docker method](#using-docker), skip to the section about [completing the conversion](#completing-the-conversion). 

#### Requirements ####

This method requires the following:

- [Fork](https://help.github.com/articles/fork-a-repo/) and [clone](https://help.github.com/articles/cloning-a-repository/) the repository that you chose in the [above section](#choosing-the-git-repository)
- pandoc (> 1.16)
- mkdocs
- MarkdownHighlight
- pygments

#### Preparing the git repository ####

1. `cd` into your local git repository
3. Add `opensciencegrid/technology` as the upstream remote repository for merging upstream changes:

        :::console
        [user@client ~ ] $ git remote add upstream https://www.github.com/opensciencegrid/%RED%<REPOSITORY>%ENDCOLOR%.git

4. Create a branch for the document you plan to convert:

        :::console
        [user@client ~ ] $ git branch %RED%<BRANCH NAME>%ENDCOLOR% master

5. Change to the branch you just created

        :::console
        [user@client ~ ] $ git checkout %RED%<BRANCH NAME>%ENDCOLOR%

#### Archiving the TWiki document ####

Follow the instructions for [archival](#archiving-documents) then continue to the next section to convert the document with pandoc.

#### Initial conversion with Pandoc ####

[Pandoc](http://pandoc.org/) is a tool that's useful for automated conversion of markdown languages. [Once installed](http://pandoc.org/installing.html) (alternatively, run pandoc [via docker](#using-docker)), run the following command to convert TWiki to Markdown:

```console
$ pandoc -f twiki -t markdown_github %RED%<TWIKI FILE>%ENDCOLOR% > %RED%<MARKDOWN FILE>%ENDCOLOR%
```

Where `<TWIKI FILE>` is the path to initial document in raw TWiki and `<MARKDOWN FILE>` is the path to the resulting document in GitHub Markdown.

!!! note
    If you don't see output from the above command quickly, it means that Pandoc is having an issue with a specific section of the document. Stop the command (or docker container), find and temporarily remove the offending section, convert the remainder of the document with Pandoc, and manually convert the offending section.

##### Using pandoc via docker ######

The `pandoc` library is written in Haskell and is frequently updated, meaning it may be unavailable on your distribution of choice - or too old.  If you cannot install `pandoc` but have access to docker, you can run the following command:

```bash
docker run -v `pwd`:/source jagregory/pandoc -f twiki -t markdown_github %RED%<TWIKI FILE>%ENDCOLOR% > %RED%<MARKDOWN FILE>%ENDCOLOR%
```

For example, to do a Docker-based conversion of the document at https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/SHA2Compliance, one would do:

```bash
$ mkdir -p archive docs/projects
$ curl 'https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/SHA2Compliance?raw=text' | iconv -f windows-1252 > archive/SHA2Compliance
$ docker run -v `pwd`/docs/:/source jagregory/pandoc -f twiki -t markdown_github /source/archive/SHA2Compliance > docs/projects/sha2-support.md
```

We have found some cases where the Docker version of `pandoc` handles Twiki syntax better than the EPEL one; YMMV.  Testing also shows that the conversion process is only about 80% accurate and each document will require a few minutes of manual touch-up.  The above example required no formatting changes.

#### Previewing your document(s) with Mkdocs ####

[Mkdocs](http://www.mkdocs.org/) has a development mode that can be used to preview documents as you work on them and is available via package manager or `pip`. [Once installed](http://www.mkdocs.org/#installation), add your document(s) to the `pages` section of `mkdocs.yml` and launch the mkdocs server with the following command from the dir containing `mkdocs.yml`:

```console
$ PYTHONPATH=src/ mkdocs serve
```

Access the server at `http://127.0.0.1:8000` and navigate to the document you're working on. It's useful to open the original TWiki doc in an adjacent tab or window to quickly compare the two.

Completing the conversion
-------------------------

Manual review of the automatically converted documents are required since the automatic conversion process isn't perfect. This section contains a list of problems commonly encountered in automatically converted documents.

### Broken links ###

Pandoc isn't aware of the entire TWiki structure so internal links using [WikiWords](http://twiki.org/cgi-bin/view/TWiki/WikiWord) result in broken links. If the broken link is for a document that has already been migrated to GitHub, link to it using relative paths to the markdown doc of interest. If the broken link is for a document that hasn't been migrated to GitHub, consult the documentation spreadsheet (contact Brian L for access) to see if it's targeted for archival.

If the broken link is:

1. For a document that has already been migrated to GitHub, update it to point at the new location.
2. For a document that not been migrated to GitHub, consult the documentation spreadsheet (contact Brian L for access):
    - If the link is targeted for archival, remove the link if it makes sense. If you're unsure, be sure to mention it in your final pull request
    - If the link is not targeted for archival, link directly to the TWiki page.

### Broken command blocks and file snippets ###

Pandoc doesn't do a good job of converting our `<pre class=...` blocks so manual intervention is required. Command blocks and file snippets should be wrapped in three backticks (\`\`\`) followed by an optional code highlighting format:

    ```python
    # stuff
    ```

Make sure to use the TWiki document as a reference when making fixes!

We use the [Pygments](http://pygments.org/) highlighting library for syntax; it knows about 100 different languages.  The Pygments website contains a live renderer if you want to see how your text will come out.  Please use the `console` language for shell sessions.

#### Fixing root and user prompts ####

| Find and replace...                                   | With...             |
|:------------------------------------------------------|:--------------------|
| `<span class="twiki-macro UCL\_PROMPT\_ROOT"></span>` | `[root@client ~] #` |
| `<span class="twiki-macro UCL\_PROMPT"></span>`       | `[user@client ~] $` |

#### Highlighting user input  ####

Within command blocks and file snippets, we've used `&lt;...&gt;` to highlight areas that users would have to insert text specific to their site. For now, use desciptive, all-caps text wrapped in angle brackets to indicate user input. You may also use TWiki-style color highlighting. 

```console
[root@client ~]# condor_ce_trace -d %RED%<CE HOSTNAME>%ENDCOLOR%
```

#### Ordered Lists ####

Ordered lists are often broken up into multiple lists if there are command blocks/file snippets and/or additional text within one of the list items. To make sure the contents of an item are indented properly, use the following formatting:

- For code blocks or file snippets, add an empty line after any regular text, then insert `(N+1)*4` spaces at the beginning of each line, where N is the level of the item in the list. To apply code highlighting, start the code block with `:::<FORMAT>`; see [this page](http://squidfunk.github.io/mkdocs-material/extensions/codehilite/) for details, including possible highlighting formats.  For an example of formatting a code section inside a list, see [the release series document](https://github.com/opensciencegrid/docs/blob/master/docs/release/release_series.md).
- For additional text (i.e. after a code block), insert `N*4` spaces at the beginning of each line, where N is the level of the item in the list.

For example:

```markdown
1. Foo
    - Bar

            :::console
            COMMAND
            BLOCK
        text associated with Bar

    text associated with Foo

2. Baz

        FILE
        SNIPPET

```

There are 12 spaces and 8 spaces in front of the command block and text associated with `Bar`, respectively; 4 spaces in front of the text associated with `Foo`; and 8 spaces in front of the file snippet associated with `Baz`.  The above block is rendered below:

1. Foo
    - Bar

            :::console
            COMMAND
            BLOCK
        text associated with Bar

    text associated with Foo

2. Baz

        FILE
        SNIPPET

### Notes ###

To catch the user's attention for important items or pitfalls, we used `%NOTE%` TWiki macros, these can be replaced with admonition-style notes and warnings:

```
!!! note
    things to note
```

or

```
!!! warning
    if a user doesn't do this thing, bad stuff will happen
```

The above blocks are rendered below as an example.

!!! note
    things to note

and

!!! warning
    if a user doesn't do this thing, bad stuff will happen

### Obvious errors ###

If you see any other obvious errors (e.g., links to gratia web), feel free to correct them while you're editing the doc *iff* the changes take less than ~15 minutes. This isn't a renovation project!

Archiving Documents
-------------------

If the document is slated for archival (check if it says "yes" in the  "archived" column of the spreadsheet), just download the document to the `archive` folder of your local git repository:

``` console
[user@client ~ ] $ cd technology/
[user@client ~ ] $ curl '%RED%<TWIKI URL>%ENDCOLOR%?raw=text' | iconv -f windows-1252 > archive/%RED%<TWIKI TITLE>%ENDCOLOR%
```

For example:

``` console
[user@client ~ ] $ cd technology
[user@client ~ ] $ curl 'https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/SHA2Compliance?raw=text' | iconv -f windows-1252 > archive/SHA2Compliance
```

After downloading the document, continue onto the next section to walk through pull request submission.

Submitting the pull request
---------------------------

1. Stage the archived raw TWiki (as well as the converted Markdown document(s) and `mkdocs.yml` if you are converting the document):

        :::console
        [user@client ~ ] $ git add mkdocs.yaml archive/%RED%<TWIKI ARCHIVE>%ENDCOLOR% %RED%<PATH TO CONVERTED DOC>%ENDCOLOR%

2. Commit and push your changes to your GitHub repo:

        :::console
        [user@client ~ ] $ git commit -m "%RED%<COMMIT MSG>%ENDCOLOR%"
        [user@client ~ ] $ git push origin %RED%<BRANCH NAME>%ENDCOLOR%

3. Open your browser and navigate to your GitHub fork
4. Submit a pull request containing with the following body:

        %RED%<LINK TO TWIKI DOCUMENT>%ENDCOLOR%

        - [ ] Enter date into "Migrated" column of google sheet

    - If you are migrating a document, also add this task:

            - [ ] Add migration header to TWiki document

    - If you are archiving a document, add this task:

            - [ ] Move TWiki document to the trash

See an example pull request [here](https://github.com/opensciencegrid/technology/pull/98).

After the pull request
----------------------

After the pull request is merged, replace the contents of TWiki document with the div if you're migrating the document, linking to the location of the migrated document:

```
<div style="border: 1px solid black; margin: 1em 0; padding: 1em; background-color: #FFDDDD; font-weight: 600;">
This document has been migrated to !GitHub (<LINK TO GITHUB DOCUMENT>). If you wish to see the old TWiki document, click the latest revision 'rNN' in the footer below.

Background:

At the end of year (2017), the TWiki will be retired in favor of !GitHub. You can find the various TWiki webs and their new !GitHub locations listed below:

   * Release3: https://opensciencegrid.github.io/docs ([[https://github.com/opensciencegrid/docs/tree/master/archive][archive]])
   * !SoftwareTeam: https://opensciencegrid.github.io/technology ([[https://github.com/opensciencegrid/technology/tree/master/archive][archive]]
</div>
```

If you are archiving a document, move it to the trash instead. Once the document has been updated or trashed, add the date to the spreadsheet and go back to your pull request and mark your tasks as complete. For example, if you completed the migration of a document:

```
- [X] Enter date into "Migrated" column of google sheet
- [X] Add migration div to TWiki document
```
Currently, we do not recommend changing backlinks (links on other twiki pages that refer to the Twiki page you are migrating) to point at the new GitHub URL.  This is to provide a simple reminder to users that the migration will occur, and also is likely low priority regardless as all pages will eventually migrate to GitHub.  This advice may change in the future as we gain experience with this transition.

Reviewing pull requests
-----------------------

To review pull requests, `cd` into the dir containing your git repository and check out the requester's branch, which the twiki-converter container should automatically notice. Here's an example checking out Brian's `cut-sw-release` branch of the technology repository:

```console
# Add the requester's repo as a remote if you haven't already
[user@client ~ ] $ git remote add blin https://www.github.com/brianhlin/technology.git
[user@client ~ ] $ git fetch --all
[user@client ~ ] $ git checkout blin/cut-sw-release
```

Refresh your browser and navigate to the document in the request.
