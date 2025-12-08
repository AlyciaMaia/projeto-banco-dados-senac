-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Plano`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Plano` (
  `idPlano` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `nivel_recursos` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idPlano`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Empresa` (
  `cnpj` CHAR(14) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `email_contato` VARCHAR(45) NOT NULL,
  `Plano_idPlano` INT NOT NULL,
  PRIMARY KEY (`cnpj`),
  INDEX `fk_Empresa_Plano1_idx` (`Plano_idPlano` ASC) VISIBLE,
  CONSTRAINT `fk_Empresa_Plano1`
    FOREIGN KEY (`Plano_idPlano`)
    REFERENCES `mydb`.`Plano` (`idPlano`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Endereco` (
  `rua` VARCHAR(45) NOT NULL,
  `cep` VARCHAR(45) NOT NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `numero` INT NOT NULL,
  `bairro` VARCHAR(15) NOT NULL,
  `Empresa_cnpj` CHAR(14) NOT NULL,
  INDEX `fk_Endereço_Empresa_idx` (`Empresa_cnpj` ASC) VISIBLE,
  PRIMARY KEY (`Empresa_cnpj`),
  CONSTRAINT `fk_Endereço_Empresa`
    FOREIGN KEY (`Empresa_cnpj`)
    REFERENCES `mydb`.`Empresa` (`cnpj`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SistemaMonitorado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SistemaMonitorado` (
  `idSistema monitorado` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `tipo` VARCHAR(45) NOT NULL,
  `ip` VARCHAR(45) NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `Empresa_cnpj` CHAR(14) NOT NULL,
  PRIMARY KEY (`idSistema monitorado`),
  INDEX `fk_Sistema monitorado_Empresa1_idx` (`Empresa_cnpj` ASC) VISIBLE,
  CONSTRAINT `fk_Sistema monitorado_Empresa1`
    FOREIGN KEY (`Empresa_cnpj`)
    REFERENCES `mydb`.`Empresa` (`cnpj`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`usuario` (
  `cpf` CHAR(11) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `senha` VARCHAR(45) NOT NULL,
  `cargo` VARCHAR(45) NOT NULL,
  `nivel_acesso` VARCHAR(45) NOT NULL,
  `data_cadastro` DATE NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `Empresa_cnpj` CHAR(14) NOT NULL,
  PRIMARY KEY (`cpf`),
  INDEX `fk_usuario_Empresa1_idx` (`Empresa_cnpj` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_Empresa1`
    FOREIGN KEY (`Empresa_cnpj`)
    REFERENCES `mydb`.`Empresa` (`cnpj`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Relatorio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Relatorio` (
  `idRelatorio` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NOT NULL,
  `tipo` VARCHAR(15) NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `data_geracao` DATE NOT NULL,
  `nivel_risco` VARCHAR(45) NOT NULL,
  `Sistema monitorado_idSistema monitorado` INT NOT NULL,
  `cpf_usuario` CHAR(11) NULL,
  PRIMARY KEY (`idRelatorio`),
  INDEX `fk_Relatorio_Sistema monitorado1_idx` (`Sistema monitorado_idSistema monitorado` ASC) VISIBLE,
  INDEX `fk_Relatorio_usuario1_idx` (`cpf_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_Relatorio_Sistema monitorado1`
    FOREIGN KEY (`Sistema monitorado_idSistema monitorado`)
    REFERENCES `mydb`.`SistemaMonitorado` (`idSistema monitorado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relatorio_usuario1`
    FOREIGN KEY (`cpf_usuario`)
    REFERENCES `mydb`.`usuario` (`cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vulnerabilidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`vulnerabilidade` (
  `idVulnerabilidade` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NOT NULL,
  `tipo` VARCHAR(15) NOT NULL,
  `dataHora` DATETIME NOT NULL,
  `risco` VARCHAR(45) NOT NULL,
  `idSistema monitorado` INT NOT NULL,
  PRIMARY KEY (`idVulnerabilidade`),
  INDEX `fk_vulnerabilidade_Sistema monitorado1_idx` (`idSistema monitorado` ASC) VISIBLE,
  CONSTRAINT `fk_vulnerabilidade_Sistema monitorado1`
    FOREIGN KEY (`idSistema monitorado`)
    REFERENCES `mydb`.`SistemaMonitorado` (`idSistema monitorado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Alerta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Alerta` (
  `idAlerta` INT NOT NULL AUTO_INCREMENT,
  `nive_Urgencia` VARCHAR(15) NOT NULL,
  `tipo` VARCHAR(15) NOT NULL,
  `local` VARCHAR(45) NOT NULL,
  `dataHora` DATETIME NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `status` VARCHAR(15) NOT NULL,
  `idVulnerabilidade` INT NULL,
  `idSistema monitorado` INT NOT NULL,
  PRIMARY KEY (`idAlerta`),
  INDEX `fk_Alerta_vulnerabilidade1_idx` (`idVulnerabilidade` ASC) VISIBLE,
  INDEX `fk_Alerta_Sistema monitorado1_idx` (`idSistema monitorado` ASC) VISIBLE,
  CONSTRAINT `fk_Alerta_vulnerabilidade1`
    FOREIGN KEY (`idVulnerabilidade`)
    REFERENCES `mydb`.`vulnerabilidade` (`idVulnerabilidade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Alerta_Sistema monitorado1`
    FOREIGN KEY (`idSistema monitorado`)
    REFERENCES `mydb`.`SistemaMonitorado` (`idSistema monitorado`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`InteracaoIA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`InteracaoIA` (
  `idInteração IA` INT NOT NULL AUTO_INCREMENT,
  `dataHora` DATETIME NOT NULL,
  `pergunta` VARCHAR(45) NULL,
  `resposta` VARCHAR(45) NOT NULL,
  `cpf_usuario` CHAR(11) NULL,
  PRIMARY KEY (`idInteração IA`),
  INDEX `fk_Interação IA_usuario1_idx` (`cpf_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_Interação IA_usuario1`
    FOREIGN KEY (`cpf_usuario`)
    REFERENCES `mydb`.`usuario` (`cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`LogSistema`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`LogSistema` (
  `idLog do Sistema` INT NOT NULL AUTO_INCREMENT,
  `dataHora` DATETIME NOT NULL,
  `evento` VARCHAR(15) NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `Sistema monitorado_idSistema monitorado` INT NOT NULL,
  `cpf_usuario` CHAR(11) NULL,
  PRIMARY KEY (`idLog do Sistema`),
  INDEX `fk_Log do Sistema_Sistema monitorado1_idx` (`Sistema monitorado_idSistema monitorado` ASC) VISIBLE,
  INDEX `fk_Log do Sistema_usuario1_idx` (`cpf_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_Log do Sistema_Sistema monitorado1`
    FOREIGN KEY (`Sistema monitorado_idSistema monitorado`)
    REFERENCES `mydb`.`SistemaMonitorado` (`idSistema monitorado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Log do Sistema_usuario1`
    FOREIGN KEY (`cpf_usuario`)
    REFERENCES `mydb`.`usuario` (`cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
