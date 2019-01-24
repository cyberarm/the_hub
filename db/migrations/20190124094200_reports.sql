-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
create TABLE reports(
  id INTEGER NOT NULL PRIMARY KEY,
  monitor_id INTEGER NOT NULL,
  payload TEXT NOT NULL,

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
drop TABLE reports;