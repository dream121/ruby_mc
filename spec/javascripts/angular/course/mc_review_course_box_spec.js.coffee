#= require spec_helper

describe 'mcReviewCourseBox directive', ->
  beforeEach module('masterclassApp')

  afterEach inject ($httpBackend) ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  describe 'given no existing review', ->
    beforeEach inject ($compile, $rootScope) ->
      $rootScope.someCourse =
        course_id: 173
      this.element = $compile('<div mc-review-course-box="someCourse"></div>')($rootScope)
      setFixtures(this.element) # so visibility checks work
      $rootScope.$digest()

    it 'displays an empty star rating', ->
      emptyStarCount = $(this.element).find('.rating-star:not(.on)').length
      expect(emptyStarCount).toBe(5)

    it 'displays an empty textarea for the review', ->
      textareaCount = $(this.element).find('textarea').length
      expect(textareaCount).toBe(1)

    it 'hides the POST button', ->
      submitButton = $(this.element).find('input[type="submit"]')
      expect(submitButton).not.toBeVisible()

    it 'shows the POST button and hides stars on textarea focus', ->
      stars = $(this.element).find('.stars')
      textarea = $(this.element).find('textarea')
      submitButton = $(this.element).find('input[type="submit"]')

      expect(stars).toBeVisible()
      expect(submitButton).not.toBeVisible()

      textarea.focus()
      expect(stars).not.toBeVisible()
      expect(submitButton).toBeVisible()

      textarea.blur()
      expect(stars).toBeVisible()
      expect(submitButton).not.toBeVisible()

    it 'creates a review with the chosen star rating', inject ($httpBackend) ->
      $httpBackend
        .expect('POST', '/api/v1/course_reviews', (data) -> JSON.parse(data).course_review.rating == 3)
        .respond({rating: 3})

      thirdStar = $(this.element).find('.rating-star:nth-child(3)')
      thirdStar.click()
      $httpBackend.flush()

      fullStarCount = $(this.element).find('.rating-star.on').length
      expect(fullStarCount).toBe(3)

    it 'updates latest review with the server response', inject ($httpBackend, $rootScope) ->
      $httpBackend
        .expect('POST', '/api/v1/course_reviews', (data) -> JSON.parse(data).course_review.rating == 3)
        .respond({id: 14, rating: 3})

      thirdStar = $(this.element).find('.rating-star:nth-child(3)')
      thirdStar.click()
      $httpBackend.flush()

      expect($rootScope.someCourse.latest_review.id).toBe(14)

    it 'creates a review with the provided text when POST is clicked', inject ($httpBackend, $rootScope) ->
      $httpBackend
        .expect('POST', '/api/v1/course_reviews', (data) -> JSON.parse(data).course_review.review == 'some review')
        .respond({review: 'some review'})

      textarea = $(this.element).find('textarea')
      submitButton = $(this.element).find('input[type="submit"]')

      textarea.focus().val('some review').trigger('change')
      submitButton.click()
      $httpBackend.flush()

      # TODO: expect the text area to be replaced with a div and the edit pencil button

    xit 'hides the POST button on blur'

  describe 'given an exiting review', ->
    beforeEach inject ($compile, $rootScope) ->
      $rootScope.someCourse =
        course_id: 173
        latest_review:
          id: 14
          rating: 4
          review: 'awesome!'
      this.element = $compile('<div mc-review-course-box="someCourse"></div>')($rootScope)
      $rootScope.$digest()

    it 'displays the star rating', ->
      fullStarCount = $(this.element).find('.rating-star.on').length
      expect(fullStarCount).toBe(4)

    it 'displays the review text', ->
      # TODO: won't be a textarea, just a div
      textarea = $(this.element).find('textarea')
      expect(textarea.val()).toBe('awesome!')

    it 'updates the star rating when changed', inject ($httpBackend) ->
      $httpBackend
        .expect('PUT', '/api/v1/course_reviews/14', (data) -> JSON.parse(data).course_review.rating == 3)
        .respond({rating: 3, review: 'awesome!'})

      thirdStar = $(this.element).find('.rating-star:nth-child(3)')
      thirdStar.click()
      $httpBackend.flush()

      fullStarCount = $(this.element).find('.rating-star.on').length
      expect(fullStarCount).toBe(3)

    it 'updates the review text when the edit button is clicked and a review text change is posted', inject ($httpBackend) ->
      $httpBackend
        .expect('PUT', '/api/v1/course_reviews/14', (data) -> JSON.parse(data).course_review.review == 'some review')
        .respond({review: 'some review', rating: 4})

      # TODO: click edit button
      textarea = $(this.element).find('textarea')
      textarea.focus().val('some review').trigger('change')

      submitButton = $(this.element).find('input[type="submit"]')
      submitButton.click()
      $httpBackend.flush()
