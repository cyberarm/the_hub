-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
create TABLE api_keys(
  id INTEGER NOT NULL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  token VARCHAR(255) NOT NULL,
  application_name VARCHAR(255) NOT NULL,
  last_access_ip VARCHAR(255) NOT NULL,

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
drop TABLE api_keys;