CREATE TABLE artist (
a_id PRIMARY KEY NOT NULL,
name  VARCHAR(30) NOT NULL
);

CREATE TABLE painting (
a_id  integer NOT NULL references artist(a_id),
p_id NOT NULL PRIMARY KEY,
title text NOT NULL,
state VARCHAR(2) NOT NULL,
price integer
);

INSERT INTO artist VALUES
(1,'Da Vinci'),
(2, 'Monet'),
(3, 'Van Gogh'),
(4, 'Picasso'),
(5, 'Renoir');

INSERT INTO painting VALUES
(1,1,'The Mona Lisa','MI', 61),
(3,2,'Starry Night', 'KY', 49),
(3,3,'The Potato Eaters', 'KY', 49),
(3,4,'The Rocks', 'IA', 50),
(5,5,'Les Deux Soeurs', 'NE' ,64),
(1,6, 'The Last Supper', 'IN', 60);

