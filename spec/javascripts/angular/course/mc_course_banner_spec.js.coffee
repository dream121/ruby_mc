#= require spec_helper

describe 'mcCourseBanner directive', ->
  beforeEach module('masterclassApp')

  beforeEach inject ($compile, $rootScope) ->
    $rootScope.someCourse =
      show_url: 'http://www.example.com/some-course'
      instructor_name: 'Meryl Streep'
      skill: 'Acting'
    this.element = $compile('<div mc-course-banner="someCourse"></div>')($rootScope)
    $rootScope.$digest()

  it 'displays the instructor name and skill they are teaching', ->
    expect(this.element.text()).toContain('Meryl Streep')
    expect(this.element.text()).toContain('teaches you Acting')
