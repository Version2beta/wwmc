#!/usr/bin/env coffee
skills = require './skills.json'
{MongoClient} = require 'mongodb'

skills = skills.map (skill) ->
  if !!skill.dependencies
    console.log skill.dependencies
    skill.dependencies = skill.dependencies.split ','
    console.log skill.dependencies
  else
    skill.dependencies = null
  return skill

MongoClient.connect 'mongodb://localhost:27017/wwmc', (err, db) ->
  throw err if err
  db.collection('skills').insert skills, (err, docs) ->
    throw err if err
    console.log docs
    db.close()
