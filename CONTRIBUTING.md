## Contributing

[The Epiverse-TRACE][cp-site] is an open source
project, and we welcome contributions of all kinds: new documentation, fixes to
existing material, bug reports, and reviews of proposed changes are all
welcome.

### Contributor Agreement

By contributing, you agree that we may redistribute your work under [our
license](LICENSE.md). In exchange, we will address your issues and/or assess
your change proposal as promptly as we can, and help you become a member of our
community. Everyone involved in [The Epiverse-TRACE][cp-site] agrees to abide by
our [code of conduct](CODE_OF_CONDUCT.md).

### How to Contribute

The easiest way to get started is to file an issue to tell us about a spelling
mistake, some awkward wording, or a factual error. This is a good way to
introduce yourself and to meet some of our community members.

1. If you do not have a [GitHub][github] account, you can [send us comments by
   email][contact]. However, we will be able to respond more quickly if you use
   one of the other methods described below.

2. If you have a [GitHub][github] account, or are willing to [create
   one][github-join], but do not know how to use Git, you can report problems
   or suggest improvements by [creating an issue][repo-issues]. This allows us
   to assign the item to someone and to respond to it in a threaded discussion.

3. If you are comfortable with Git, and would like to add or change material,
   you can submit a pull request (PR). Instructions for doing this are
   [included below](#using-github). For inspiration about changes that need to
   be made, check out the [list of open issues][issues].

Note: if you want to build the website locally, please refer to [The Workbench
documentation][template-doc].

### Where to Contribute

1. If you wish to change this tutorial, add issues and pull requests here.
2. If you wish to change the template used for workshop websites, please refer
   to [The Workbench documentation][template-doc].


### What to Contribute

There are many ways to contribute, from writing new exercises and improving
existing ones to updating or filling in the documentation and submitting [bug
reports][issues] about things that do not work, are not clear, or are missing.
If you are looking for ideas, please see [the list of issues for this
repository][repo-issues].

Comments on issues and reviews of pull requests are just as welcome: we are
smarter together than we are on our own. **Reviews from novices and newcomers
are particularly valuable**: it's easy for people who have been using these
tutorials for a while to forget how impenetrable some of this material can be, so
fresh eyes are always welcome.

### What *Not* to Contribute

Our tutorials already contain more material than we can cover in a typical
workshop, so we are usually *not* looking for more concepts or tools to add to
them. As a rule, if you want to introduce a new idea, you must (a) estimate how
long it will take to teach and (b) explain what you would take out to make room
for it. The first encourages contributors to be honest about requirements; the
second, to think hard about priorities.

We are also not looking for exercises or other material that only run on one
platform. Our workshops typically contain a mixture of Windows, macOS, and
Linux users; in order to be usable, our tutorials must run equally well on all
three.

### Contribution roles

For a tutorial your role could be of a __Developer__, __Reviewer__, or __Maintainer__. Our goal is to keep an homogeneous package environment among Developers and Reviewers of a “development branch” different to main. This implies that:

- We will use [`sandpaper::use_package_cache()`](https://carpentries.github.io/sandpaper/reference/package_cache.html#background) in the R project.
- The Developer will need to register the package version to use in a `renv.lock` file.
- The Reviewer will need to restore environment defined by Developer, if needs to build the website locally.


#### Developer:

If you need to work with the most recent versions:

- Use [`sandpaper::update_cache()`](https://carpentries.github.io/sandpaper/reference/dependency_management.html). This will: 
  + Fetch updates from CRAN or GitHub,
  + Update the `renv.lock` file with package specific versions, and
  + Update the cache. This is located in a folder called `renv/library/` in the same directory of the `renv.lock`, only visible locally.
- Push the updated `renv.lock` file to the GitHub “development branch”.

If you need to work with a specific stable version:

- Use [`sandpaper::pin_version()`](https://carpentries.github.io/sandpaper/articles/building-with-renv.html#pinning-specific-package-versions). This will:
  + Update the `renv.lock` file with the specific version,
  + Update the cache.
- Push the updated `renv.lock` file.

#### Reviewer:

You can follow this steps:

- Clone the repo or Pull the branch on Rstudio.
- Checkout to the branch to review.
- Use [`renv::restore()`](https://carpentries.github.io/sandpaper/reference/dependency_management.html#details) to align the packages in your cache with the ones in the `renv.lock` file (defined by the Developer).
- Render lesson with [`sandpaper::build_lesson()`](https://carpentries.github.io/sandpaper/reference/build_lesson.html). This will open an html tab in your browser to review.
- Make any edit suggestion in the `.Rmd` files inside the `episodes/` folder.

#### Maintainer:

You can follow this references:

- Update these steps from any discussion on issues.
- Review how to [maintain a Healthy Infrastructure](https://carpentries.github.io/sandpaper-docs/update.html).
- Review how to [Automate a Pull Request](https://carpentries.github.io/sandpaper-docs/pull-request.html#automated-pull-requests). Lessons outside of the carpentries need to [set up a Pull Request bot](https://carpentries.github.io/sandpaper-docs/pull-request.html#automated-pull-requests) with the [Carpentries Apprentice bot](https://github.com/carpentries-bot).


### Using GitHub

If you choose to contribute via GitHub, you may want to look at [How to
Contribute to an Open Source Project on GitHub][how-contribute]. In brief, we
use [GitHub flow][github-flow] to manage changes:

1. Create a new branch in your desktop copy of this repository for each
   significant change.
2. Commit the change in that branch.
3. Push that branch to your fork of this repository on GitHub.
4. Submit a pull request from that branch to the [upstream repository][repo].
5. If you receive feedback, make changes on your desktop and push to your
   branch on GitHub: the pull request will update automatically.

NB: The published copy of the lesson is usually in the `main` branch.

Each lesson has a team of maintainers who review issues and pull requests or
encourage others to do so. The maintainers are community volunteers, and have
final say over what gets merged into the lesson.

### Other Resources

The Epiverse-TRACE is a global organisation with volunteers and learners all over
the world. We share values of inclusivity and a passion for sharing knowledge,
teaching and learning. There are several ways to connect with The Epiverse-TRACE
community listed at <https://github.com/epiverse-trace/> including via social
media, slack, newsletters, and email lists. You can also [reach us by
email][contact].

[repo]: https://example.com/FIXME
[repo-issues]: https://github.com/epiverse-trace/tutorials/issues
[contact]: mailto:andree.valle-campos@lshtm.ac.uk
[cp-site]: https://epiverse-trace.github.io/
[dc-issues]: https://github.com/issues?q=user%3Adatacarpentry
[dc-lessons]: https://datacarpentry.org/lessons/
[dc-site]: https://datacarpentry.org/
[discuss-list]: https://carpentries.topicbox.com/groups/discuss
[github]: https://github.com
[github-flow]: https://guides.github.com/introduction/flow/
[github-join]: https://github.com/join
[how-contribute]: https://egghead.io/courses/how-to-contribute-to-an-open-source-project-on-github
[issues]: https://github.com/epiverse-trace/tutorials/issues
[lc-issues]: https://github.com/issues?q=user%3ALibraryCarpentry
[swc-issues]: https://github.com/issues?q=user%3Aswcarpentry
[swc-lessons]: https://software-carpentry.org/lessons/
[swc-site]: https://software-carpentry.org/
[lc-site]: https://librarycarpentry.org/
[template-doc]: https://carpentries.github.io/workbench/