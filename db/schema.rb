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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_12_074420) do

  create_table "auto_test_projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gitlab_id"
    t.integer "classroom_id"
    t.index ["classroom_id"], name: "index_auto_test_projects_on_classroom_id"
  end

  create_table "blogs", force: :cascade do |t|
    t.integer "gitlab_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "classroom_id"
    t.string "blog_type"
    t.index ["classroom_id"], name: "index_blogs_on_classroom_id"
    t.index ["user_id"], name: "index_blogs_on_user_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.integer "gitlab_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_project_subgroup_id"
    t.integer "personal_project_subgroup_id"
    t.integer "pair_project_subgroup_id"
  end

  create_table "contribution_commits", force: :cascade do |t|
    t.string "gitlab_id"
    t.integer "team_project_id"
    t.datetime "committed_at"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_project_id"], name: "index_contribution_commits_on_team_project_id"
    t.index ["user_id"], name: "index_contribution_commits_on_user_id"
  end

  create_table "contribution_issues", force: :cascade do |t|
    t.integer "issue_id"
    t.integer "team_project_id"
    t.datetime "closed_at"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_contribution_issues_on_issue_id"
    t.index ["team_project_id"], name: "index_contribution_issues_on_team_project_id"
    t.index ["user_id"], name: "index_contribution_issues_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority"
    t.string "state"
    t.integer "project_id"
    t.integer "milestone_id"
  end

  create_table "select_classrooms", force: :cascade do |t|
    t.integer "user_id"
    t.integer "classroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_select_classrooms_on_classroom_id"
    t.index ["user_id"], name: "index_select_classrooms_on_user_id"
  end

  create_table "student_test_records", force: :cascade do |t|
    t.integer "project_id"
    t.string "score"
    t.string "unittest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "auto_test_project_id"
    t.integer "user_id"
    t.string "feedback"
    t.integer "pipeline_id"
    t.index ["auto_test_project_id"], name: "index_student_test_records_on_auto_test_project_id"
    t.index ["user_id"], name: "index_student_test_records_on_user_id"
  end

  create_table "team_projects", force: :cascade do |t|
    t.integer "gitlab_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "classroom_id"
    t.index ["classroom_id"], name: "index_team_projects_on_classroom_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "role"
    t.integer "gitlab_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
  end

end
