'use strict';

const handlebars = require('handlebars');
const { promises: { readFile } } = require('fs');
const buildPaths = require('./build-paths');

// A helper to turn a datetime into a human readable string.
handlebars.registerHelper('humanDate', datetime => new Date(datetime).toDateString());

// A helper to turn a datetime into an ISO string (without milliseconds).
handlebars.registerHelper('isoDate', datetime => new Date(datetime)
  .toISOString()
  .replace(/\.[0-9]{3}Z/, 'Z')
);

// Loads and renders a partial template.
exports.loadPartial = async templateName => {
  const name = templateName.slice(0, templateName.indexOf('.'));
  const source = await readFile(buildPaths.src('templates', `${templateName}.handlebars`), 'utf-8');

  handlebars.registerPartial(name, source);
};

// Loads a template from the filesystem and compiles it to a function.
exports.loadTemplate = async templateName => {
  const source = await readFile(buildPaths.src('templates', `${templateName}.handlebars`), 'utf-8');

  return handlebars.compile(source);
};