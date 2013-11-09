# on hover, expand

layoutSkills = (skills) ->
  windowWidth = $(window).width()
  windowHeight = $(window).height()

  # width of screen is 4 years
  hScale = windowWidth / (12 * 4)
  vScale = 36

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
        skillStartWithinRowSkill = skill.developmentalAge >= rowSkill.developmentalAge && skill.developmentalAge < rowSkillEnd
        # is skill right between rowSkill left and right
        skillEndWithinRowSkill = skillEnd > rowSkill.developmentalAge && skillEnd < rowSkillEnd

        # is rowSkill left between skill left and right
        rowSkillStartWithinSkill = rowSkill.developmentalAge > skill.developmentalAge && rowSkill.developmentalAge < skillEnd
        # is rowSkill right between skill left and right
        rowSkillEndWithinSkill = rowSkillEnd > skill.developmentalAge && rowSkillEnd < skillEnd

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
      left: ((skill.developmentalAge - 1) * hScale) + 'px'
      row: rowIndex
      top: (rowIndex * vScale) + 'px'
    }

    skill.id = skill._id



window.HomeCtrl = ($scope, $http, $modal) ->
  reLayout = ->
    layoutSkills $scope.skills

  $(window).on 'resize', ->
    $scope.$apply reLayout

  $http.get('/skills')
    .success (skills) ->
      $scope.skills = skills
      reLayout()
    .error (err) ->
      alert "Error loading skills: #{err}"

  $scope.open = (datas) ->
    $modal.open {
      templateUrl: 'views/modal.html'
      controller: ModalCtrl
      resolve: {
        data: -> return datas
      }
    }

  $scope.showDependencies = (skill) ->
    s.dependency = "dependency" for s in $scope.skills when s._id in (skill.dependencies or [])

  $scope.hideDependencies = ->
    for s in $scope.skills
      delete s.dependency
