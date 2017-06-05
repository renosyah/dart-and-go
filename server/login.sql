CREATE TABLE "user" (
	username STRING NULL,
	password STRING NULL,
	FAMILY "primary" (username, password, rowid)
);

INSERT INTO "user" (username, password) VALUES
	('jihar', '12345'),
	('reno', '12345');
