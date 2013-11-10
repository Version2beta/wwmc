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
          height: vScale + 'px'
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

centerPointForSkill = (skill) ->
  left = parseFloat skill.layout.left
  top = parseFloat skill.layout.top
  width = parseFloat skill.layout.width
  {
    left: width / 2 + left
    top: 30 / 2 + top
  }

window.HomeCtrl = ($scope, skills) ->
  $scope.skills = skills

  # idk how to do this correctly :(
  dependencyCtx = document.querySelector(".dependencyLines").getContext("2d")

  skillsById = _.indexBy skills, 'id'
  highlightedDependencies = []

  reLayout = ->
    windowWidth = $(window).width()
    # width of screen is 4 years
    hScale = windowWidth / (12 * 4)
    vScale = 36
    topPadding = 40
    hPadding = 30

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

  reLayout()
  $(window).on 'resize', ->
    $scope.$apply reLayout

  $scope.open = (skill) ->
    if skill.detail != "detail"
      $scope.showDependencies(skill)
      for s in $scope.skills
        s.detail = null
      skill.detail = "detail"
    false

  $scope.close = (skill) ->
    console.log skill
    skill.detail = null
    $scope.hideDependencies(skill)

  $scope.showDependenciesOrOpen = (skill) ->
    if skill.active
      $scope.open(skill)
    else
      $scope.hideDependencies(skill)
      $scope.showDependencies(skill)

  drawDependencies = (skill, depth=0) ->
    return if depth > 10 # prevent infinite loops on cyclic structures
    skillPosition = centerPointForSkill skill

    dependencies = (skill.dependencies or []).map (id) ->
      skillsById[id]

    for dependency in dependencies
      dependencyPosition = centerPointForSkill dependency
      dependencyCtx.moveTo skillPosition.left, skillPosition.top
      dependencyCtx.lineTo dependencyPosition.left, dependencyPosition.top
      dependency.dependency = "dependency"
      dependencies = dependencies.concat drawDependencies dependency, depth

    dependencies

  $scope.showDependencies = (skill) ->
    skill.active = "active"

    dependencyCtx.beginPath()
    highlightedDependencies = drawDependencies skill
    dependencyCtx.strokeStyle = "rgba(0, 0, 0, 0.5)"
    dependencyCtx.lineWidth = 3
    dependencyCtx.stroke()

    highlightedDependencies.push skill

  $scope.hideDependencies = ->
    dependencyCtx.clearRect 0, 0, $scope.skillsWidth, $scope.skillsHeight
    while dep = highlightedDependencies.pop()
      dep.active = null
      dep.detail = null
      dep.dependency = null
