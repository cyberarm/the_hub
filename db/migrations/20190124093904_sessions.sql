-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
create TABLE sessions(
  id INTEGER NOT NULL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  token VARCHAR(255) NOT NULL,
  user_ip VARCHAR(255) NOT NULL,

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
drop TABLE sessions;