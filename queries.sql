/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE EXTRACT(year FROM date_of_birth) BETWEEN 2016 AND 2019;
SELECT name FROM animals WHERE neutered AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

/*Transactions*/

BEGIN;

UPDATE animals
SET species = 'unspecified';

SELECT * FROM animals;

ROLLBACK;

SELECT * FROM animals;

BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

COMMIT;

/* Delete all records in the animals table and roll back afterwards */

BEGIN;
DELETE FROM animals;
-- Verify that animals are deleted

SELECT * FROM animals;
ROLLBACK;

-- Delete all animals born after January 1 2022

DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

-- Create a savepoint and update and rollback savepoint all animals' weight multiplied by -1 to their weight.

SAVEPOINT sv1;
UPDATE animals
SET weight_kg = -1 * weight_kg;

ROLLBACK TO sv1;

-- Update all animals' weights that are negative to be their weight multiplied by -1.

UPDATE animals
SET weight_kg = -1 * weight_kg
WHERE weight_kg < 0;

COMMIT;
SELECT * FROM animals;

-- Aggregates

SELECT COUNT(*) FROM animals;

SELECT COUNT(*) FROM animals 
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) FROM animals;

SELECT neutered, MAX(escape_attempts) FROM animals
GROUP BY neutered;

SELECT species, MIN(weight_kg),
MAX(weight_kg) from animals
GROUP BY species;

SELECT species, AVG(escape_attempts) FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;