categoryColors = [
  "#DFEF8F"
  "#8FEF95"
  "#EFBA8F"
  "#EF9A8F"
  "#EF8FB5"
]

layoutSkills = ($scope, {hScale, vScale, topPadding, hPadding}) ->

  $scope.skillsHeight = 0
  $scope.skillsWidth = 0

  categories = []

  for skill in $scope.skills
    category = _.find categories, (category) ->
      category.name == skill.categories

    if !category
      category = { name: skill.categories, rows: [] }
      categories.push category

    rows = category.rows

    # find the first row this skill can fit in
    row = _.find rows, (row) ->
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
    if !row
      row = { skills: [] }
      rows.push row

    row.skills.push skill

  rowIndex = 0
  for category in categories
    for row in category.rows
      for skill in row.skills
        width = skill.developmentalAgeRange * hScale
        top = rowIndex * vScale + topPadding
        left = skill.developmentalAge * hScale + hPadding
        skill.layout = {
          width: width + 'px'
          left: left + 'px'
          row: rowIndex
          top: top + 'px'
        }

        $scope.skillsHeight = Math.max (top + vScale - topPadding), $scope.skillsHeight
        $scope.skillsWidth = Math.max (left + width + hPadding), $scope.skillsWidth

      rowIndex++

  $scope.categories = categories.map (category, i) ->
    {
      name: category.name
      height: category.rows.length * vScale
      backgroundColor: categoryColors[i]
    }

layoutTimeline = ($scope, {hScale, vScale, maxMonth, topPadding, hPadding}) ->
  $scope.timelineNotches = for month in [0..maxMonth] by 3
    {
      month
      left: (hScale * month + hPadding) + 'px'
    }

window.HomeCtrl = ($scope, $http, $modal) ->
  reLayout = ->
    windowWidth = $(window).width()

    # width of screen is 4 years
    hScale = windowWidth / (12 * 4)
    vScale = 36
    topPadding = 40
    hPadding = 16

    $scope.vScale = vScale
    $scope.hScale = hScale

    layoutSkills $scope, {
      hScale
      vScale
      topPadding
      hPadding
    }


    maxSkill = _.max $scope.skills, (skill) ->
      skill.developmentalAge + skill.developmentalAgeRange

    maxMonth = maxSkill.developmentalAge + maxSkill.developmentalAgeRange
    maxYear = Math.floor maxMonth / 12

    $scope.years = [0..maxYear].map (year) ->
      {
        year
        left: (hScale * 12 * year + hPadding) + 'px'
      }

    layoutTimeline $scope, {
      hScale
      vScale
      topPadding
      hPadding
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

  $scope.showDependencies = (skill) ->
    skill.active = "active"
    for s in $scope.skills
      if s._id in (skill.dependencies or [])
        s.dependency = "dependency"
        $scope.showDependencies(s)
      else
        s.dependency = "hide-dependency" if not s.active
        #s.dependency = "dependency" for s in $scope.skills when s._id in (skill.dependencies or [])

  $scope.hideDependencies = ->
    for s in $scope.skills
      delete s.active
      delete s.dependency
