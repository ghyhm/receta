@javascript
Feature: Search Recipe

  Scenario: Search a recipe
    Given there are the following recipies
      | name                   |
      | Baked Potato w/ Cheese |
      | Garlic Mashed Potatoes |
      | Potatoes Au Gratin     |
      | Baked Brussel Sprouts  |
    When user goes to recipes page
    And user searches recipe with keyword "baked"
    Then the following recipes are shown
      | name                   |
      | Baked Potato w/ Cheese |
      | Baked Brussel Sprouts  |
      