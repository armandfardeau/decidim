# frozen_string_literal: true

class AddAnswerDateToDecidimInitiative < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_initiatives, :answer_date, :datetime, null: true
  end
end
