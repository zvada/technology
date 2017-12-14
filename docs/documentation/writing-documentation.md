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
