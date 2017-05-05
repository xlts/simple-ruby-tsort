require_relative 'course_validator'
v = CourseValidator.new('course.txt')
puts v.course_valid?
puts v.get_order
