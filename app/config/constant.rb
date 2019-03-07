class Constant
  if Rails.env == 'production'
    include ::ProductionConstant
  else
    include ::DevelopmentConstant
  end
end