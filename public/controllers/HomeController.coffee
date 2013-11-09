
vScale = 46
hScale = 10 # pixels per month

layoutSkills = (skills) ->
  rows = [{
    skills: []
  }]

  for skill in skills
    # find the first row this skill can fit in
    rowIndex = _.findIndex rows, (row) ->
      for rowSkill in row.skills
        skillEnd = skill.developmentalAge + skill.developmentalAgeRange
        rowSkillEnd = rowSkill.developmentalAge + rowSkill.developmentalAgeRange

        # is skill left between rowSkill left and right
        skillStartWithinRowSkill = skill.developmentalAge >= rowSkill.developmentalAge && skill.developmentalAge <= rowSkillEnd
        # is skill right between rowSkill left and right
        skillEndWithinRowSkill = skillEnd >= rowSkill.developmentalAge && skillEnd <= rowSkillEnd

        # is rowSkill left between skill left and right
        rowSkillStartWithinSkill = rowSkill.developmentalAge >= skill.developmentalAge && rowSkill.developmentalAge <= skillEnd
        # is rowSkill right between skill left and right
        rowSkillEndWithinSkill = rowSkillEnd >= skill.developmentalAge && rowSkillEnd <= skillEnd

        if skillStartWithinRowSkill || skillEndWithinRowSkill || rowSkillStartWithinSkill || rowSkillEndWithinSkill
          # it overlaps
          return false

      # it doesnt overlap any other skills in this row
      return true

    # add another row if we can't fit in any existing rows
    if rowIndex == -1
      row = {
        skills: []
      }
      rows.push row
      rowIndex = rows.length - 1
    else
      row = rows[rowIndex]

    row.skills.push skill


    width = skill.developmentalAgeRange * hScale
    skill.layout = {
      width: width + 'px'
      left: (skill.developmentalAge * hScale) + 'px'
      row: rowIndex
      top: (rowIndex * vScale) + 'px'
    }

  skills





window.HomeCtrl = ($scope) ->

  skills = for i in [0..100]
    {
      _id: "23",
      title: "Eye hand movement",
      description: "Eye–hand movements better coordinated; can put objects together, take them apart; fit large pegs into pegboard.",
      developmentalAge: Math.floor(Math.random() * 128),
      developmentalAgeRange: Math.floor(Math.random() * 20) + 6,
      dependencies: [
      ],
      categories: [
        "cognitive"
      ]
    }

  $scope.skills = layoutSkills skills
