Fabricator(:answer) do
  user
  question_type "tool_quiz"
  question_id { rand(700) }
  correct { rand(2) == 1 }
end