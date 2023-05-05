/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES 
('Agumon', '2020-02-03', 0, true, 10.23), 
('Gabumon', '2018-11-15', 2, true, 8),
('Pikachu', '2021-01-7', 1, false, 15.04),
('Devimon', '2017-05-12', 5, true, 11);

/* Adding new animal data */

INSERT INTO animals  (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES 
('Charmander', '2020-02-08', 0, false,-11), 
('Plantmon', '2021-11-15', 2, true, -5.7), 
('Squirtle', '1993-04-02', 3, false, -12.13), 
('Angemon', '2005-06-12', 1, true, -45), 
('Boarmon', '2005-06-07', 7, true, 20.4), 
('Blossom', '1998-10-13', 3, true, 17), 
('Ditto', '2022-05-14', 4, true, 22);

-- Insert data into owners

INSERT INTO owners (full_name, age)
VALUES ('Sam Smith', 34),
       ('Jennifer Orwell', 19),
       ('Melody Pond', 77),
       ('Dean Winchester', 14),
       ('Jodie Whittaker', 38);

-- Insert data into species

INSERT INTO species (name)
VALUES ('Pokemon'),
       ('Digimon');

-- Inserting species_id in animals table

UPDATE animals 
SET species_id = 
  CASE 
    WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
    ELSE (SELECT id FROM species WHERE name = 'Pokemon')
  END;

-- Modify inserted animals to include (owner_id)

UPDATE animals 
SET owner_id = 
  CASE 
    WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
    WHEN name IN ('Gabumon', 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
    WHEN name IN ('Devimon', 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
    WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
    WHEN name IN ('Angemon', 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
  END;

-- Insert data for vets table
INSERT INTO vets (name, age, date_of_graduation)
  VALUES ('William Tatcher', 45, '2000-04-23'),
         ('Maisy Smith', 26, '2019-01-17'),
         ('Stephanie Mendez', 64, '1981-05-04'),
         ('Jack Harkness', 38, '2008-06-08');

 -- Insert data for vets specilizations
 INSERT INTO specializations (vet_id, species_id)
  VALUES ((SELECT id FROM vets WHERE name = 'William Tatcher'), (SELECT id FROM species WHERE name = 'Pokemon')),
         ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM species WHERE name = 'Digimon')),
         ((SELECT id FROM vets WHERE name = 'Stephanie Mendez'), (SELECT id FROM species WHERE name = 'Pokemon')),
         ((SELECT id FROM vets WHERE name = 'Jack Harkness'), (SELECT id FROM species WHERE name = 'Digimon'));

-- Insert data for visits
INSERT INTO visits (animal_id, vet_id, visit_date)
  VALUES (1, 1, '2020-05-24'),
         (1, 3, '2020-07-22'),
         (2, 4, '2021-02-02'),
         (7, 2, '2020-01-05'),
         (7, 2, '2020-03-08'),
         (7, 2, '2020-05-14'),
         (3, 3, '2021-05-04'),
         (8, 4, '2021-02-24'),
         (4, 1, '2020-08-10'),
         (4, 2, '2021-04-07'),
         (9, 3, '2019-09-29'),
         (5, 4, '2020-10-03'),
         (5, 4, '2020-11-04'),
         (6, 4, '2005-06-06'),
         (6, 2, '2019-01-24'),
         (6, 2, '2019-05-15'),
         (6, 2, '2020-02-27'),
         (6, 2, '2020-08-03'),
         (10, 1, '2021-01-11');