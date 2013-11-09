# Importing data

## Skills

Initially, Jenni is entering skills into a Google spreadsheet. To import, follow these steps:

0. Download the spreadsheet as a CSV.
0. Paste it into http://www.convertcsv.com/csv-to-json.htm to convert to JSON. The first row is column names.
0. Copy the resulting JSON into scripts/skills.json.
0. Run `./scripts/import_skills.coffee`.

This is drop the skills collection and repopulate it with the new data, including remapping the skill IDs.
