# Practicals

The goal of the `##-practical-tutors.qmd` files in this folder is to host complementary challenges to solve in groups during syncronous trainings. The `##-` referes to the week number to deliver each material.

## Usage

One Quarto QMD file generates:

- Tutors MD file: for Tutors to use during practical or propose edits. Saved as `files/##-practical-tutors.md`.
- Guide DOCX file: for Learners to complete during the practical. Saved as `files/##-practical-guide.docx`.
- Solutions HTML file: for Learners to be shared after the practical. Saved as `files/##-practical-solutions.html`.

Each Quarto QMD file is linked to:

- Activity R files: for Learners to complete during the practical. Saved as `data/##-practical-activity-x.R`.

## Features

We are using Quarto:

- Multi format <https://quarto.org/docs/output-formats/html-multi-format.html>
- Contidional content <https://quarto.org/docs/authoring/conditional.html>
- Self-contained HTMLs <https://quarto.org/docs/output-formats/html-basics.html#self-contained>
- Includes <https://quarto.org/docs/authoring/includes.html>
- Output file names <https://stackoverflow.com/a/73589592/6702544>
- Project options <https://quarto.org/docs/reference/projects/options.html>

<!-- With the limitation that we can not differentiate content for MD outputs. Using alternatives suggested in the following issue <https://github.com/quarto-dev/quarto-cli/issues/6705>. -->

## Contributing

For contributions, please:

- Download and install the latest Quarto release from <https://quarto.org/docs/download/>
- Edit _only_ the QMD file that renders all the above files.
- Commit QMD files jointly with MD outputs.

To render the QMD file, you can use the [`{quarto}`](https://cran.r-project.org/web/packages/quarto/index.html) R package. For example, to render practical number 4:

```r
quarto::quarto_render(input = here::here("instructors", "04-practical-tutors.qmd"))
```

## Mantainer 

To Do list:

- [ ] render the quarto QMD file
- [ ] share a clean the DOCX file in on Google Drive
- [ ] upload link to DOCX file to Moodle
- [ ] share MD file with Tutors
- [ ] upload HTML to Moodle
