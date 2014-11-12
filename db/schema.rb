# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141101223628) do

  create_table "assessment_task_proficiencies", :force => true do |t|
    t.string   "proficiency"
    t.integer  "assessment_task_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "assessment_task_proficiencies", ["assessment_task_id"], :name => "index_assessment_task_proficiencies_on_assessment_task_id"

  create_table "assessment_task_resources", :force => true do |t|
    t.string   "resource"
    t.integer  "assessment_task_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "assessment_task_resources", ["assessment_task_id"], :name => "index_assessment_task_resources_on_assessment_task_id"

  create_table "assessment_tasks", :force => true do |t|
    t.string   "title"
    t.date     "due"
    t.integer  "weighting"
    t.text     "synopsis"
    t.text     "feedback"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "assessment_tasks", ["course_id"], :name => "index_assessment_tasks_on_course_id"

  create_table "course_improvements", :force => true do |t|
    t.string   "description"
    t.integer  "course_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "course_improvements", ["course_id"], :name => "index_course_improvements_on_course_id"

  create_table "course_learning_outcomes", :force => true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "course_learning_outcomes", ["course_id"], :name => "index_course_learning_outcomes_on_course_id"

  create_table "courses", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "semester_id"
    t.integer  "units_of_credit"
    t.string   "teaching_times_and_locations"
    t.string   "online_course_support"
    t.string   "parallel_teaching"
    t.text     "summary"
    t.text     "course_aims"
    t.text     "teaching_philosophy"
    t.text     "assessment"
    t.text     "resources"
    t.integer  "program_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "status"
  end

  create_table "criteria", :force => true do |t|
    t.string   "criteria"
    t.string   "fail"
    t.string   "pass"
    t.string   "credit"
    t.string   "distinction"
    t.string   "high_distinction"
    t.integer  "assessment_task_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "criteria", ["assessment_task_id"], :name => "index_criteria_on_assessment_task_id"

  create_table "members", :force => true do |t|
    t.integer  "associate_id"
    t.integer  "user_id"
    t.string   "associate_type"
    t.string   "role"
    t.string   "consultation_times"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "parameters", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "programs", :force => true do |t|
    t.integer  "number"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "semesters", :force => true do |t|
    t.string   "name"
    t.string   "year"
    t.date     "start"
    t.date     "end"
    t.date     "non_teaching_week"
    t.date     "mid_semester_break"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "task_outcomes", :force => true do |t|
    t.integer  "assessment_task_id"
    t.integer  "course_learning_outcome_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "teaching_strategies", :force => true do |t|
    t.boolean  "lectures",                   :default => false
    t.string   "lectures_description"
    t.boolean  "seminars",                   :default => false
    t.string   "seminars_description"
    t.boolean  "tutorials",                  :default => false
    t.string   "tutorials_description"
    t.boolean  "studio",                     :default => false
    t.string   "studio_description"
    t.boolean  "blended_online",             :default => false
    t.string   "blended_online_description"
    t.string   "teaching_philosophy"
    t.integer  "course_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "teaching_strategies", ["course_id"], :name => "index_teaching_strategies_on_course_id"

  create_table "topics", :force => true do |t|
    t.integer  "week"
    t.date     "date"
    t.string   "topic_name"
    t.string   "tasks_due"
    t.string   "bgcolor"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "topics", ["course_id"], :name => "index_topics_on_course_id"

  create_table "users", :force => true do |t|
    t.string   "zid",                           :null => false
    t.string   "fullname",                      :null => false
    t.string   "email",         :default => ""
    t.string   "phone_number",  :default => ""
    t.string   "mobile_number", :default => ""
    t.string   "room",          :default => ""
    t.string   "role",          :default => ""
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

end
