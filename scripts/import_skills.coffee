#!/usr/bin/env coffee
skills = require './skills.json'
{MongoClient} = require 'mongodb'

skills = skills.map (skill) ->
  if !!skill.dependencies
    skill.dependencies = skill.dependencies.split ','
  else
    skill.dependencies = null
  return skill

skillIdMapper = (skills, id) ->
  (skill._id for skill in skills when skill.skillId == +id)[0]

remapDependencies = (skills) ->
  skills.map (skill) ->
    if skill.dependencies
      skill.dependencies = skill.dependencies.map (dependency) ->
        skillIdMapper skills, dependency
    skill

MongoClient.connect 'mongodb://localhost:27017/wwmc', (err, db) ->
  throw err if err
  collection = db.collection('skills')
  collection.drop (err) ->
    throw err if err
    collection.insert skills, (err, docs) ->
      throw err if err
      for doc in remapDependencies docs
        collection.update {"_id": doc._id}, {"$set": {"dependencies": doc.dependencies}, "$unset": {"skillId": true}}, {}, (err) ->
          throw err if err
      db.close()
