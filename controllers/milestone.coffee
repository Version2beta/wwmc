Milestone = require '../models/milestone'

module.exports = {
  getMilestones: (req, res, next) ->
    Milestone.findAll (err, milestones) ->
      return next err if err
      res.json milestones

  getMilestonesById: (req, res, next) ->
    milestoneIds = req.param('ids').split ','
    Milestone.findByIds milestoneIds, (err, milestones) ->
      return next err if err
      res.json milestones

}
