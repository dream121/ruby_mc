module NavbarHelper
  NAVBAR_MAP  = {
    'accounts' =>
    {
      'edit' => {
        'nspacer_height' => '34'
      }
    },
    'courses' =>
    {
      'show_enrolled' =>
      {
        'nspacer_height' => '22'
      },
      'show' =>
      {
        'nspacer_height' => '34'
      }
    },
    'carts' =>
    {
      'show' =>
      {
        'nspacer_height' => '34'
      }
    },
    'chapters' =>
    {
      'watch' => {
        'nspacer_height' => '34'
      }
    },
    'office_hours' =>
    {
      'index' =>
      {
        'nspacer_height' => '34'
      }
    },
    'students' =>
    {
      'index' =>
      {
        'nspacer_height' => '22'
      },
      'show' =>
      {
        'nspacer_height' => '22'
      },
      'new' =>
      {
        'nspacer_height' => '22'
      },
      'edit' =>
      {
        'nspacer_height' => '22'
      }
    },
    'instructors' =>
    {
      'index' =>
      {
        'nspacer_height' => '22'
      },
      'show' =>
      {
        'nspacer_height' => '22'
      },
      'new' =>
      {
        'nspacer_height' => '22'
      },
      'edit' =>
      {
        'nspacer_height' => '22'
      }
    }
  }

  def navbar_map
    NAVBAR_MAP
  end

  def neg_height
    if navbar_map[controller.controller_name] && navbar_map[controller.controller_name][controller.action_name]
      navbar_map[controller.controller_name][controller.action_name]['nspacer_height']
    else
      '70'
    end
  end

  def nav_bg_id
    if controller.controller_name == 'office_hours' && controller.action_name == 'index'
      ''
    else
      'mc-nav-background'
    end
  end
end
