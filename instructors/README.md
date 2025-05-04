# Practicals

The goal of the `practical.qmd` files in this folder is to host complementary challenges to solve in groups during syncronous trainings.

## Usage

One Quarto file generates:

- Tutors MD file: for Tutors to study or propose edits.
- Guide DOCX file: for Learners to use during the practical session.
- Activity RMD file: for Learners to complete during the practical session.
- Solutions HTML file: for Learners to share after the practical session.

## Features

We are using Quarto:

- Multi format <https://quarto.org/docs/output-formats/html-multi-format.html>
- Contidional content <https://quarto.org/docs/authoring/conditional.html>
- Self-contained HTMLs <https://quarto.org/docs/output-formats/html-basics.html#self-contained>
- Includes <https://quarto.org/docs/authoring/includes.html>
- Output file names <https://stackoverflow.com/a/73589592/6702544>

With the limitation that we can not differentiate content for MD outputs. Using alternatives suggested in the following issue <https://github.com/quarto-dev/quarto-cli/issues/6705>.

## Contributing

For contributions, please:

- Edit _only_ the QMD file that renders all the above files.
- Commit QMD files jointly with MD outputs.

To render the QMD file, you can use the terminal. For example, to render practical number 4:

```bash
$ quarto render .\instructors\04-practical-tutors.qmd
```

## Mantainer 

To Do list:

- [ ] render the quarto file
- [ ] share a clean the DOCX file in on Google Drive
- [ ] upload link to DOCX file to Moodle
- [ ] share MD file with Tutors
- [ ] upload HTML to Moodle
