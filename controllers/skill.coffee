Skill = require '../models/skill'

module.exports = {
  getSkills: (req, res, next) ->
    Skill.findAll (err, skills) ->
      return next err if err
      res.json skills

  getSkillsById: (req, res, next) ->
    skillIds = req.param('ids').split ','
    Skill.findByIds skillIds, (err, skills) ->
      return next err if err
      res.json skills
}
