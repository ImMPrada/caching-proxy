class CreateCachedResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :cached_responses do |t|
      t.text :url, null: false
      t.string :http_method, null: false, limit: 10
      t.jsonb :request_headers
      t.jsonb :response_headers
      t.text :response_body
      t.timestamp :created_at, null: false
      t.timestamp :expires_at
    end

    add_index :cached_responses, %i[url http_method]
  end
end
