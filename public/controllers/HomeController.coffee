# on hover, expand

layoutSkills = ($scope, {hScale, vScale}) ->

  skillHeight = 30
  $scope.skillsHeight = 0
  $scope.skillsWidth = 0

  rows = [{
    skills: []
  }]

  for skill in $scope.skills
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
    top = rowIndex * vScale
    left = skill.developmentalAge * hScale
    skill.layout = {
      width: width + 'px'
      left: left + 'px'
      row: rowIndex
      top: top + 'px'
    }

    $scope.skillsHeight = Math.max (top + skillHeight), $scope.skillsHeight
    $scope.skillsWidth = Math.max (left + width), $scope.skillsWidth


layoutTimeline = ($scope, {hScale, vScale, maxMonth}) ->
  $scope.timelineNotches = for month in [0..maxMonth] by 3
    {
      month
      left: hScale * month + 'px'
    }

window.HomeCtrl = ($scope, $http, $modal) ->
  reLayout = ->
    windowWidth = $(window).width()

    # width of screen is 4 years
    hScale = windowWidth / (12 * 4)
    vScale = 36

    $scope.vScale = vScale
    $scope.hScale = hScale

    layoutSkills $scope, {
      hScale
      vScale
    }


    maxSkill = _.max $scope.skills, (skill) ->
      skill.developmentalAge + skill.developmentalAgeRange

    maxMonth = maxSkill.developmentalAge + maxSkill.developmentalAgeRange
    maxYear = Math.floor maxMonth / 12

    $scope.years = [0..maxYear].map (year) ->
      {
        year
        left: hScale * 12 * year + 'px'
      }

    layoutTimeline $scope, {
      hScale
      vScale
      maxMonth
    }

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
