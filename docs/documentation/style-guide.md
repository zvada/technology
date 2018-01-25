Markdown Style Guide
====================

This document contains markdown conventions that are used in OSG Software documentation.

Meta
----

Wherever possible, prose should be limited to 120 characters wide.
In addition, using one line for each sentence is recommended since it makes update diffs easier to review.

Headings
--------

Use the following conventions for headings:

- The title should be the only level 1 heading
- Level 1 headings should use the `====` format
- Level 2 headings should use the `----` format
- Other heading levels should use the appropriate number of `#` up to a maximum of level 5 headings.
  Spin-off a new document or re-organize the existing document if you find that you regularly need level 5 headings.
- Use Title Case for level 1 and level 2 headings. Only capitalize the first word for all other headings.

Links
-----

Use site-relative (`/software/development-process`) instead of document-relative (`../software/development-process.md`)
links. This will allow us to easily search for links and move documents around in the future.

### Section links ###

To link sections within a page, lowercase the entire section name and replace spaces with dashes. If there are multiple
sections with the same name you can link the subsequent sections by appending `_N` where `N` is the section's ordinal
number minus one, e.g. append `_1` for the second section. For example, if you have three sections named "Optional
Configuration", link them like so:

```
[1st section](#optional-configuration)
[2nd section](#optional-configuration_1)
[3rd section](#optional-configuration_2)
```

Command blocks and file snippets
--------------------------------

Command blocks and file snippets outside of lists should be wrapped in three back-ticks (\`\`\`) followed by an optional
code highlighting format:

    ```console
    # stuff
    ```

For command blocks and file snippets that inside of a list should use the appropriate number of spaces before three
colons followed by an optional code highlighting format:

```
::: console
# stuff
```

See the [lists section](#lists) for details on properly formatting command blocks within a list.

We use the [Pygments](http://pygments.org/) highlighting library for syntax; it knows about 100 different languages.
The Pygments website contains a live renderer if you want to see how your text will come out.  Please use the `console`
language for shell sessions.

### Root and user prompts ###

When specifying instructions for the command-line, indicate to users whether the commands can be run as root 
(`root@host # `) or as an unprivileged user (`user@host $ `).

For example:

```console
root@host # useradd -m osguser
root@host # su - osguser
user@host $ whoami
osguser
```

It can provide helpful context to use a more specific hostname in the prompt than `host`.
For example, if you're writing a doc for setting up a Storage Element and a command is run as root on the SE, use `root@se # `.
Or if you're testing the SE from the client side and the command is run as a normal user on a client, use `user@client $ `.

### Highlighting user input  ###

Use descriptive, all-caps text wrapped in angle brackets to to highlight areas that users would have to insert text
specific to their site. You may also use TWiki-style color highlighting. For example:

```console
root@host # condor_ce_trace -d %RED%<CE HOSTNAME>%ENDCOLOR%
```

Lists
-----

When constructing lists, use the following guidelines:

- Use `1.` for each item in a numbered list
- To make sure the contents of code blocks, file snippets, and subsequent paragraphs are indented properly, use the
  following formatting:
    - For code blocks or file snippets, add an empty line after any regular text, then insert `(N+1)*4` spaces at the
      beginning of each line, where N is the level of the item in the list. To apply code highlighting, start the code
      block with `:::<FORMAT>`; see [this page](http://squidfunk.github.io/mkdocs-material/extensions/codehilite/) for
      details, including possible highlighting formats.  For an example of formatting a code section inside a list, see
      [the release series document](https://github.com/opensciencegrid/docs/blob/master/docs/release/release_series.md).
    - For additional text (i.e. after a code block), insert `N*4` spaces at the beginning of each line, where N is the
      level of the item in the list.

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

There are 12 spaces and 8 spaces in front of the command block and text associated with `Bar`, respectively; 4 spaces in
front of the text associated with `Foo`; and 8 spaces in front of the file snippet associated with `Baz`.  The above
block is rendered below:

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

Notes
-----

To catch the user's attention for important items or pitfalls, we used `%NOTE%` TWiki macros, these can be replaced with
admonition-style notes and warnings:

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

!!! note things to note

and

!!! warning if a user doesn't do this thing, bad stuff will happen

For a full list of admonition styles, see the documentation
[here](https://squidfunk.github.io/mkdocs-material/extensions/admonition/).
