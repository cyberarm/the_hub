-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
create TABLE monitors(
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(255) NOT NULL,
  update_interval FLOAT,
  domain VARCHAR(255),
  game VARCHAR(255),
  key VARCHAR(255),

  save_reports INT,
  max_reports INT,

  reports_count INT DEFAULT 0,

  last_error TEXT,

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
drop TABLE monitors;