DROP DATABASE IF EXISTS imperio_leste;
CREATE DATABASE imperio_leste
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE imperio_leste;

-- ============================================================
-- 1. TABELAS
-- ============================================================

CREATE TABLE margem_lucro (
    id_margem INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(120) NOT NULL,
    percentual DECIMAL(6,2) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NULL,
    status ENUM('ATIVO','INATIVO') NOT NULL DEFAULT 'ATIVO',
    CONSTRAINT chk_margem_percentual CHECK (percentual > 0),
    CONSTRAINT chk_margem_periodo CHECK (data_fim IS NULL OR data_fim >= data_inicio)
) ENGINE=InnoDB;

CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL UNIQUE,
    descricao VARCHAR(255),
    categoria VARCHAR(50) NOT NULL DEFAULT 'Pizza',
    preco_venda DECIMAL(10,2) NOT NULL,
    id_margem INT NULL,
    status ENUM('ATIVO','INATIVO') NOT NULL DEFAULT 'ATIVO',
    CONSTRAINT chk_produto_preco CHECK (preco_venda > 0),
    CONSTRAINT fk_produto_margem FOREIGN KEY (id_margem)
      REFERENCES margem_lucro(id_margem)
      ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE ingrediente (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    unidade_medida VARCHAR(20) NOT NULL,
    custo_unitario DECIMAL(10,2) NOT NULL,
    fornecedor VARCHAR(120),
    data_atualizacao DATE NOT NULL,
    status ENUM('ATIVO','INATIVO') NOT NULL DEFAULT 'ATIVO',
    CONSTRAINT chk_ingrediente_custo CHECK (custo_unitario > 0)
) ENGINE=InnoDB;

CREATE TABLE item_receita (
    id_item_receita INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    id_ingrediente INT NOT NULL,
    quantidade DECIMAL(10,3) NOT NULL,
    CONSTRAINT uq_receita UNIQUE (id_produto, id_ingrediente),
    CONSTRAINT chk_receita_quantidade CHECK (quantidade > 0),
    CONSTRAINT fk_receita_produto FOREIGN KEY (id_produto)
      REFERENCES produto(id_produto)
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_receita_ingrediente FOREIGN KEY (id_ingrediente)
      REFERENCES ingrediente(id_ingrediente)
      ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE custo_fixo (
    id_custo_fixo INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(120) NOT NULL,
    valor_mensal DECIMAL(10,2) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NULL,
    status ENUM('ATIVO','INATIVO') NOT NULL DEFAULT 'ATIVO',
    CONSTRAINT chk_custo_valor CHECK (valor_mensal >= 0),
    CONSTRAINT chk_custo_periodo CHECK (data_fim IS NULL OR data_fim >= data_inicio)
) ENGINE=InnoDB;

CREATE TABLE concorrente (
    id_concorrente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL UNIQUE,
    contato VARCHAR(100),
    endereco VARCHAR(200),
    observacoes VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE pizza_concorrente (
    id_pizza_concorrente INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    id_concorrente INT NOT NULL,
    nome_pizza_concorrente VARCHAR(120) NOT NULL,
    descricao VARCHAR(255),
    preco_praticado DECIMAL(10,2) NOT NULL,
    data_coleta DATE NOT NULL,
    fonte VARCHAR(255) NOT NULL,
    observacao VARCHAR(255),
    CONSTRAINT chk_preco_concorrente CHECK (preco_praticado > 0),
    CONSTRAINT fk_pc_produto FOREIGN KEY (id_produto)
      REFERENCES produto(id_produto)
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pc_concorrente FOREIGN KEY (id_concorrente)
      REFERENCES concorrente(id_concorrente)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- As entidades abaixo aparecem no DER mais recente enviado pelo grupo.
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(120) UNIQUE,
    endereco VARCHAR(200),
    data_cadastro DATE NOT NULL,
    status ENUM('ATIVO','INATIVO') NOT NULL DEFAULT 'ATIVO'
) ENGINE=InnoDB;

CREATE TABLE venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_venda DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observacao VARCHAR(255),
    CONSTRAINT fk_venda_cliente FOREIGN KEY (id_cliente)
      REFERENCES cliente(id_cliente)
      ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE item_venda (
    id_item_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_item_venda_qtd CHECK (quantidade > 0),
    CONSTRAINT chk_item_venda_preco CHECK (preco_unitario > 0),
    CONSTRAINT fk_iv_venda FOREIGN KEY (id_venda)
      REFERENCES venda(id_venda)
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_iv_produto FOREIGN KEY (id_produto)
      REFERENCES produto(id_produto)
      ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE usuario_autorizado (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    login VARCHAR(80) NOT NULL UNIQUE,
    autorizado_precificacao BOOLEAN NOT NULL DEFAULT FALSE,
    status ENUM('ATIVO','INATIVO') NOT NULL DEFAULT 'ATIVO'
) ENGINE=InnoDB;

-- ============================================================
-- 2. DADOS FICTÍCIOS PARA TESTE
-- ============================================================

INSERT INTO margem_lucro (descricao, percentual, data_inicio, data_fim, status) VALUES
('Margem padrão', 40.00, '2026-01-01', NULL, 'ATIVO'),
('Margem antiga', 25.00, '2025-01-01', '2025-12-31', 'INATIVO');

INSERT INTO produto (nome, descricao, categoria, preco_venda, id_margem, status) VALUES
('Pizza de Calabresa', 'Pizza tradicional de calabresa', 'Pizza', 39.90, 1, 'ATIVO'),
('Pizza de Muçarela', 'Pizza tradicional de muçarela', 'Pizza', 35.90, 1, 'ATIVO'),
('Pizza Especial', 'Pizza especial da casa', 'Pizza', 49.90, 1, 'ATIVO'),
('Pizza Descontinuada', 'Produto fora do cardápio', 'Pizza', 29.90, 2, 'INATIVO');

INSERT INTO ingrediente (nome, unidade_medida, custo_unitario, fornecedor, data_atualizacao, status) VALUES
('Massa de pizza', 'unidade', 4.50, 'Fornecedor Alfa', '2026-10-01', 'ATIVO'),
('Molho de tomate', 'kg', 8.00, 'Fornecedor Beta', '2026-10-01', 'ATIVO'),
('Muçarela', 'kg', 32.00, 'Fornecedor Gama', '2026-10-01', 'ATIVO'),
('Calabresa', 'kg', 24.00, 'Fornecedor Delta', '2026-10-01', 'ATIVO'),
('Orégano', 'kg', 40.00, 'Fornecedor Épsilon', '2026-10-01', 'ATIVO'),
('Ingrediente descontinuado', 'kg', 10.00, 'Fornecedor Zeta', '2026-10-01', 'INATIVO');

INSERT INTO item_receita (id_produto, id_ingrediente, quantidade) VALUES
(1,1,1.000), (1,2,0.150), (1,4,0.200), (1,5,0.003),
(2,1,1.000), (2,2,0.150), (2,3,0.250), (2,5,0.003),
(3,1,1.000), (3,2,0.180), (3,3,0.200), (3,4,0.150);

INSERT INTO custo_fixo (descricao, valor_mensal, data_inicio, data_fim, status) VALUES
('Aluguel', 2500.00, '2026-01-01', NULL, 'ATIVO'),
('Salários', 4000.00, '2026-01-01', NULL, 'ATIVO'),
('Energia e água', 900.00, '2026-01-01', NULL, 'ATIVO'),
('Manutenção encerrada', 250.00, '2025-01-01', '2025-12-31', 'INATIVO');

INSERT INTO concorrente (nome, contato, endereco, observacoes) VALUES
('Pizzaria Sabor da Vila', 'Contato fictício', 'Endereço fictício, São Paulo', 'Registro acadêmico fictício'),
('Pizzaria Forno Leste', 'Contato fictício', 'Endereço fictício, São Paulo', 'Registro acadêmico fictício');

INSERT INTO pizza_concorrente
(id_produto, id_concorrente, nome_pizza_concorrente, descricao, preco_praticado, data_coleta, fonte, observacao) VALUES
(1, 1, 'Calabresa', 'Pizza comparável de calabresa', 42.90, '2026-10-10', 'Cardápio fictício para teste', 'Preço fictício'),
(1, 2, 'Calabresa tradicional', 'Pizza comparável de calabresa', 38.90, '2026-10-12', 'Cardápio fictício para teste', 'Preço fictício'),
(2, 1, 'Muçarela', 'Pizza comparável de muçarela', 36.90, '2026-10-10', 'Cardápio fictício para teste', 'Preço fictício'),
(3, 2, 'Especial da casa', 'Pizza comparável especial', 52.90, '2026-10-12', 'Cardápio fictício para teste', 'Preço fictício');

INSERT INTO cliente (nome, telefone, email, endereco, data_cadastro, status) VALUES
('Ana Souza', '11990000001', 'ana.teste@example.com', 'Rua fictícia A, São Paulo', '2026-01-10', 'ATIVO'),
('Bruno Lima', '11990000002', 'bruno.teste@example.com', 'Rua fictícia B, São Paulo', '2026-02-15', 'ATIVO');

INSERT INTO venda (id_cliente, data_venda, observacao) VALUES
