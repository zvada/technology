Writing OSG Software Documentation
==================================

This document contains instructions, recommendations, and guidelines for writing OSG Software documentatation.

Contributing Documentation
--------------------------

OSG software documentation is written in [markdown](https://en.wikipedia.org/wiki/Markdown), built using [MkDocs](http://www.mkdocs.org/), and served via [GitHub Pages](https://pages.github.com/). To contribute documentation, submit a pull request to the relevant github repository:

- [Site administrator documentation](https://github.com/opensciencegrid/docs/)
- [Internal OSG Technology Area documentation](https://github.com/opensciencegrid/technology/).

### Writing new documents ###

To contribute a new document:

1. Name the document. Document file names should be lowercase, `-` delimited, and concise but descriptive, e.g. `markdown-migration.md` or `cutting-release.md`
1. Place it in the relevant sub-folder of the `docs/` directory. If you are unsure of the appropriate location, note that in the description of the pull request.
1. Add the document to the `pages:` section of `mkdocs.yml` in [title case](http://titlecase.com/), e.g. `- Migrating Documents to Markdown: 'software/markdown-migration.md'`
1. Submit your changes as a pull request to the [appropriate upstream repository](#contributing-documntation)

### Deploying ITB documentation ###

If you are a member of the software and release team, you can preview large changes to the [ITB docs](https://opensciencegrid.github.io/docs-itb/) by pushing a branch that starts with an `itb.` prefix to the `opensciencegrid/docs` repo. For example:

``` console
$ git remote add upstream https://github.com/opensciencegrid/docs.git
$ git checkout new_docs
$ git push upstream new_docs:itb.new_docs
```

!!! note
    Since there is only one ITB docs area, simultaneous new commits to different `itb.*` branches will overwrite each other's changes. To re-deploy your changes, find your [Travis-CI build](https://travis-ci.org/opensciencegrid/docs/branches) and restart it **BUT** coordinate with the author of the other commits to avoid conflicts.

Tips for Writing Procedural Instructions
----------------------------------------

- Title the procedure with the user goal, usually starting with a gerund; e.g.:

    **Installing the Frobnosticator**

- Number all steps (as opposed to using bullets)

- List steps in order in which they are performed

- Each step should begin with a single-line instruction in plain English, in command form; e.g.:
    3. Make sure that the Frobnosticator configuration file is world-writable

- If the means of carrying out the instruction is unclear or complex, include clarification, ideally in the form of a working example; e.g.:
  ```
  chmod a+x /usr/share/frobnosticator/frob.conf
  ```

- Put clarifying information in separate paragraphs within the step

- Put critical information about the **whole** procedure in one or more paragraphs before the numbered steps

- Put supplemental information about the **whole** procedure in one or more paragraphs after the numbered steps

- Avoid pronouns when writing technical articles or documentation e.g., `install foo` rather than `install it`.

Style Guide
-----------

This section contains the style guidelines for OSG software documentation.

### Introductions ###

In the past, document introductions were included in 'About this...' sections due to the layout of the table of contents. Since the table of contents is included in the sidebar, introductions should go directly below the title header.

### Headers ###

Use the following conventions for headers:

1. The title should be the only level 1 heading
1. Level 1 headings should use the `====` format
1. Level 2 sub-headings should use the `----` format
1. Use Title Case for level 1 and level 2 headings. Only capitalize the first word for all other headings.

### Links ###

Use site-relative (`/software/development-process.md`) instead of document-relative (`../software/development-process.md`) links. This will allow us to easily search for links and move documents around in the future.

#### Section links ####

To link sections within a page, lowercase the entire section name and replace spaces with dashes. If there are multiple sections with the same name you can link the subsequent sections by appending `_N` where `N` is the section's ordinal number minus one, e.g. append `_1` for the second section. For example, if you have three sections named "Optional Configuration", link them like so:

```
[1st section](#optional-configuration)
[2nd section](#optional-configuration_1)
[3rd section](#optional-configuration_2)
```

### Command blocks and file snippets ###

Command blocks and file snippets outside of lists should be wrapped in three backticks (\`\`\`) followed by an optional code highlighting format:

    ```console
    # stuff
    ```

For command blocks and file snippets that inside of a list should use the appropriate number of spaces before three colons followed by an optional code highlighting format:

```
::: console
# stuff
```

See the [lists section](#lists)

We use the [Pygments](http://pygments.org/) highlighting library for syntax; it knows about 100 different languages.  The Pygments website contains a live renderer if you want to see how your text will come out.  Please use the `console` language for shell sessions.

#### Root and user prompts ####

When specifying instructions for the command-line, indicate to users whether the commands can be run as root (`root@host # `) or as an unprivileged user (`user@host $ `). 

For example:

```console
root@host # useradd -m osguser
root@host # su - osguser
user@host $ whoami
osguser
```

#### Highlighting user input  ####

Use desciptive, all-caps text wrapped in angle brackets to to highlight areas that users would have to insert text specific to their site. You may also use TWiki-style color highlighting.

```console
root@host # condor_ce_trace -d %RED%<CE HOSTNAME>%ENDCOLOR%
```

#### Lists ####

When constructing lists, use the following guidelines:

- Use `1.` for each item in a numbered list
- To make sure the contents of code blocks, file snippets, and subsequent paragraphs are indented properly, use the following formatting:
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

1. Baz

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

1. Baz

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
