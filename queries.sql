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

-- Query multiple tables

SELECT * FROM animals 
JOIN owners ON animals.owner_id = owners.id 
WHERE owners.full_name = 'Melody Pond';

SELECT * FROM animals 
JOIN species ON animals.species_id = species.id 
WHERE species.name = 'Pokemon';

SELECT owners.full_name, animals.name FROM owners 
LEFT JOIN animals ON owners.id = animals.owner_id;

SELECT species.name, COUNT(*) FROM animals 
JOIN species ON animals.species_id = species.id 
GROUP BY species.name;

SELECT animals.name FROM animals 
JOIN owners ON animals.owner_id = owners.id 
JOIN species ON animals.species_id = species.id 
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

SELECT * FROM animals 
JOIN owners ON animals.owner_id = owners.id 
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

-- Relationships queries
SELECT animals.name AS animal_name
FROM visits
JOIN animals ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.visit_date DESC
LIMIT 1;

SELECT COUNT(DISTINCT animal_id)
FROM visits
WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez');

SELECT vets.name AS vet_name, species.name AS specialization
FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id
ORDER BY vets.name ASC;

SELECT animals.name, visits.visit_date
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez' 
AND visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30'
ORDER BY visits.visit_date;

SELECT animals.name, COUNT(*) AS num_visits
FROM animals
JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.id
ORDER BY num_visits DESC
LIMIT 1;

SELECT a.name AS animal_name, v.visit_date
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Maisy Smith'
ORDER BY v.visit_date ASC
LIMIT 1;

SELECT a.*, v.*, MAX(visits.visit_date) AS most_recent_visit
FROM visits
JOIN animals a ON visits.animal_id = a.id
JOIN vets v ON visits.vet_id = v.id
WHERE visits.visit_date = (SELECT MAX(visit_date) FROM visits)
GROUP BY a.id, v.id;

SELECT COUNT(*) AS unspecialized_visit FROM visits v
INNER JOIN animals a ON a.id = v.animal_id
INNER JOIN vets vt ON vt.id = v.vet_id
LEFT JOIN specializations s ON vt.id = s.vet_id AND a.species_id = s.species_id
WHERE s.vet_id IS NULL;


SELECT v.name AS vet_name, COUNT(DISTINCT a.species_id) AS species_count
FROM visits AS vs
JOIN animals AS a ON a.id = vs.animal_id
JOIN vets AS v ON v.id = vs.vet_id
WHERE v.name = 'Maisy Smith'
GROUP BY v.name
ORDER BY species_count DESC
LIMIT 1;