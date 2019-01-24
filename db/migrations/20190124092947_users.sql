-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
create TABLE users(
  id INTEGER NOT NULL PRIMARY KEY,
  username VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  role INTEGER NOT NULL,
  last_login_at TIMESTAMP,
  last_login_ip VARCHAR(255),

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
drop TABLE users;