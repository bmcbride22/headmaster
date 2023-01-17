class DropInstruments < ActiveRecord::Migration[7.0]
  def change
    drop_table :instrument_sections
    drop_table :instruments do |t|
      t.string 'title'
      t.bigint 'subject_id', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.text 'description'
      t.bigint 'creator_id', null: false
      t.boolean 'sectioned', default: false
      t.string 'instrument_type'
      t.index ['creator_id'], name: 'index_instruments_on_creator_id'
      t.index ['subject_id'], name: 'index_instruments_on_subject_id'
    end
  end
end
