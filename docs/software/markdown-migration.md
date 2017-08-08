Migrating to Markdown
=====================

As part of the TWiki retirement (the read-only target date of Oct 1, 2017, with a shutdown date in 2018), we will need to convert the OSG Software and Release3 docs from TWiki syntax to [Markdown](https://guides.github.com/features/mastering-markdown/). The following document outlines the conversion process and conventions.

Choosing document locations and names
-------------------------------------

`SoftwareTeam` documents should go into the [technology github repo](https://opensciencegrid.github.io/technology/) and `Release3` documents should go into the [docs github repo](https://opensciencegrid.github.io/docs/). Document file names should be lowercase, `-` delimited, and descriptive but concise, e.g. `markdown-migration.md` or `cutting-release.md`

Initial conversion with Pandoc
------------------------------

[Pandoc](http://pandoc.org/) is a tool that's useful for automated conversion of markdown languages. [Once installed](http://pandoc.org/installing.html) (alternatively, run pandoc [via docker](#using-docker)), run the following command to convert TWiki to Markdown:

```bash
pandoc -f twiki -t markdown_github <INPUT FILE> > <OUTPUT FILE>
```

Where `<INPUT FILE>` is the path to initial document in raw TWiki and `<OUTPUT FILE>` is the path to the resulting document in GitHub Markdown.

!!! note
    If you don't see output from the above command quickly, it means that Pandoc is having an issue with a specific section of the document. Find the offending section via binary search, temporarily remove the section, convert the document with Pandoc, and manually convert the offending section.

### Using docker ###

The `pandoc` library is written in Haskell and is frequently updated, meaning it may be unavailable on your distribution of choice - or too old.  If you cannot install `pandoc` but have access to docker, you can run the following command:

```bash
docker run -v `pwd`:/source jagregory/pandoc -f twiki -t markdown_github <INPUT FILE> > <OUTPUT FILE>
```

For example, to do a Docker-based conversion of the document at https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/SHA2Compliance, one would do:

```bash
$ mkdir -p docs/archive docs/projects
$ curl 'https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/SHA2Compliance?raw=text' > docs/archive/SHA2Compliance
$ docker run -v `pwd`/docs/:/source jagregory/pandoc -f twiki -t markdown_github /source/archive/SHA2Compliance > docs/projects/sha2-support.md
```

We have found some cases where the Docker version of `pandoc` handles Twiki syntax better than the EPEL one; YMMV.  Testing also shows that the conversion process is only about 80% accurate and each document will require a few minutes of manual touch-up.  The above example required no formatting changes.

Previewing your document(s) with Mkdocs
---------------------------------------

[Mkdocs](http://www.mkdocs.org/) has a development mode that can be used to preview documents as you work on them and is available via package manager or `pip`. [Once installed](http://www.mkdocs.org/#installation), add your document(s) to the `pages` section of `mkdocs.yml` and launch the mkdocs server with the following command from the dir containing `mkdocs.yml`:

```
$ PYTHONPATH=src/ mkdocs serve
```

Access the server at `http://127.0.0.1:8000` and navigate to the document you're working on. It's useful to open the original TWiki doc in an adjacent tab or window to quickly compare the two.

Things to watch out for
-----------------------

### Broken links ###

Pandoc isn't aware of the entire TWiki structure so internal links using [WikiWords](http://twiki.org/cgi-bin/view/TWiki/WikiWord) result in broken links. If the broken link is for a document that has already been migrated to GitHub, link to it using relative paths to the markdown doc of interest. If the broken link is for a document that hasn't been migrated to GitHub, consult the documentation spreadsheet (contact Brian L for access) to see if it's targeted for archival.

If the broken link is:

1. For a document that has already been migrated to GitHub, update it to point at the new location.
2. For a document that not been migrated to GitHub, consult the documentation spreadsheet (contact Brian L for access):
   a. If the link is targeted for archival, remove the link if it makes sense. If you're unsure, be sure to mention it in your final pull request
   b. If the link is not targeted for archival, link directly to the TWiki page.

### Broken command blocks and file snippets ###

Pandoc doesn't do a good job of converting our `<pre class=...` blocks so manual intervention is required. Command blocks and file snippets should be wrapped in three backticks (\`\`\`):

    ```
    # stuff
    ```

Make sure to use the TWiki document as a reference when making fixes!

#### Fixing root and user prompts ####

| Find and replace...                                   | With...             |
|:------------------------------------------------------|:--------------------|
| `<span class="twiki-macro UCL\_PROMPT\_ROOT"></span>` | `[root@client ~] $` |
| `<span class="twiki-macro UCL\_PROMPT"></span>`       | `[user@client ~] $` |

#### Highlighting user input  ####

Within command blocks and file snippets, we've used `%RED%...%ENDCOLOR%`, `&lt;...&gt;`, etc. to highlight areas that users would have to insert text specific to their site. For now, use desciptive, all-caps text wrapped in angle brackets to indicate user input:

```
[user@client ~]$ condor_ce_trace -d <CE HOSTNAME>
```

#### Ordered Lists ####

Ordered lists are often broken up into multiple lists if there are command blocks/file snippets and/or additional text within one of the list items. To make sure the contents of an item are indented properly, use the following formatting:

- For code blocks or file snippets, add an empty line after any regular text, then insert `(N+1)*4` spaces at the beginning of each line, where N is the level of the item in the list.
- For additional text (i.e. after a code block), insert `N*4` spaces at the beginning of each line, where N is the level of the item in the list.

For example:

```
1. Foo
    - Bar

            COMMAND
            BLOCK
        text associated with Bar

    text associated with Foo

2. Baz

        FILE
        SNIPPET

```

There are 12 spaces and 8 spaces in front of the command block and text associated with `Bar`, respectively; 4 spaces in front of the text associated with `Foo`; and 8 spaces in front of the file snippet associated with `Baz`

### Notes ###

To catch the user's attention for important items or pitfalls, we used `%NOTE%` TWiki macros, these can be replaced with admonition-style notes:

```
!!! note
    # things to note
```

### Obvious errors ###

If you see any other obvious errors (e.g., links to gratia web), feel free to correct them while you're editing the doc *iff* the changes take less than ~15 minutes. This isn't a renovation project!

Making the pull request
-----------------------

1. Create a branch based off of master
2. Add page to [mkdocs.yml](../../mkdocs.yml) in [title case](http://titlecase.com/), e.g. `Migrating Documents to Markdown`
3. Commit your changes and push to your GH repo
4. Make PR containing the following tasks in the body:

        <LINK TO TWIKI DOCUMENT>

        - [ ] Add migration header to TWiki document
        - [ ] Remaining TWiki link #1
        - ...
        - [ ] Remaining TWiki link #N

See an example pull request [here](https://github.com/opensciencegrid/technology/pull/82).

Adding a header to the TWiki document
-------------------------------------

After completing the migration of a document, replace the contents of TWiki document with the following header, linking to the location of the migrated document:

```
<div style="border: 1px solid black; margin: 1em 0; padding: 1em; background-color: #FFDDDD; font-weight: 600;">
This is an archive, find the new version of this document [[LINK TO GITHUB DOCUMENT][here]].

Background:

At the end of year (2017), the TWiki will be retired in favor of !GitHub. You can find the various TWiki webs and their new !GitHub locations listed below:

   * Release3: https://opensciencegrid.github.io/docs
   * !SoftwareTeam: https://opensciencegrid.github.io/technology
</div>
```

Once the header has been added, go back to your pull request and mark that task as complete:

    - [X] Add migration header to TWiki document

Currently, we do not recommend changing backlinks (links on other twiki pages that refer to the Twiki page you are migrating) to point at the new GitHub URL.  This is to provide a simple reminder to users that the migration will occur, and also is likely low priority regardless as all pages will eventually migrate to GitHub.  This advice may change in the future as we gain experience with this transition.

Reviewing pull requests
-----------------------

To review pull requests, `cd` into the dir containing your git repository, check out the requester's branch, and start a local `mkdocs` server. For example, here's an example checking out Brian's `cut-sw-release` branch of the technology repository:

```console
# Add the requester's repo as a remote if you haven't already
[user@client ~ ] $ git remote add blin https://www.github.com/brianhlin/technology.git
[user@client ~ ] $ git fetch --all
[user@client ~ ] $ git checkout blin/cut-sw-release
[user@client ~ ] $ PYTHONPATH=src/ mkdocs serve
```

Access the server at `http://127.0.0.1:8000` and navigate to the document in the request.
