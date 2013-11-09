mongoose = require 'mongoose'

Milestone = mongoose.Schema {
  name: String
  description: String
  expectedAgeStart: Number
  expectedAgeRange: Number
  category: String, enum: ['Cognitive', 'Physical'] # need more of these
  pastMilestoneIds: [mongoose.Schema.ObjectId]
}

Milestone.statics.findAll = (cb) ->
  @find({}).lean().exec cb

Milestone.statics.findByIds = (ids, cb) ->
  objectIds = ids.filter (i) -> i.match /^[0-9a-fA-F]{24}$/
  @find(_id: {$in: objectIds}).lean().exec cb

module.exports = mongoose.model 'Milestone', Milestone
