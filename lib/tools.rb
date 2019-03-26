class Tools
  def self.is_student(name)
    # 八位学号判断学生
    return false unless name.length == 8
    name.each_char do |c|
      return false if c < '0' || c > '9'
    end
    return true
  end
end