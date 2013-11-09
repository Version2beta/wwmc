mongoose = require 'mongoose'

Skill = mongoose.Schema {
  skillId: Number
  title: String
  description: String
  developmentalAge: Number
  developmentalAgeRange: Number
  category: String, enum: ['Cognitive', 'Physical'] # need more of these
  dependencies: [mongoose.Schema.ObjectId]
}

Skill.statics.findAll = (cb) ->
  @find({}).lean().exec cb

Skill.statics.findByIds = (ids, cb) ->
  objectIds = ids.filter (i) -> i.match /^[0-9a-fA-F]{24}$/
  @find(_id: {$in: objectIds}).lean().exec cb

module.exports = mongoose.model 'Skill', Skill
