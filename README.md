# FX-MDT

FX-MDT is a work in progress re-imagination of a mdt made in Svelte

# THIS RESOURCE ISNT FINISHED

## Installation

dont download it 

## Usage


## Contributing
```lua
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
```

Please make sure to update tests as appropriate.

## Features

normal mdt (?)

## IMAGES

![Hi](https://image.prntscr.com/image/K9IGW_uHRCe1JHfF4j3zvw.png)
![Hi](https://image.prntscr.com/image/2F2kSWJqRl2DncrG7IvDSg.png)
![Hi](https://image.prntscr.com/image/yNWXjyUVRmmXHebAu7XgSA.png)

## Bugs or TO-DO

```lua
* Check if is police before opening the tablet

* Finish Vehicle section.

* Finish Report section.
```
# THANKS

Special thanks to TASO! and Project Error for his NUI boilerplate

  https://github.com/project-error/svelte-lua-boilerplate


# License

	MIT


# SQL

```sql
	CREATE TABLE `fx_reports` (
	`id` TINYTEXT NOT NULL COLLATE 'utf8_general_ci',
	`citizenid` TINYTEXT NOT NULL COLLATE 'utf8_general_ci',
	`name` CHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`lastname` CHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`location` CHAR(70) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`vehicleplate` VARCHAR(15) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`information` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`evidencia` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`imagenes` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`fine` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`policesinvolved` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`jailtime` TINYINT(4) NULL DEFAULT NULL,
	`amount` TINYINT(4) NULL DEFAULT NULL,
	CONSTRAINT `evidencia` CHECK (json_valid(`evidencia`)),
	CONSTRAINT `imagenes` CHECK (json_valid(`imagenes`)),
	CONSTRAINT `fine` CHECK (json_valid(`fine`)),
	CONSTRAINT `policesinvolved` CHECK (json_valid(`policesinvolved`))
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

```