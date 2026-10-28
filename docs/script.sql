-- ============================================================
-- 2. DADOS FICTÍCIOS
-- ============================================================

INSERT INTO cliente (nome, telefone, email, endereco, data_cadastro, status) VALUES
('Ana Souza', '11990000001', 'ana.teste@example.com', 'Rua A, São Paulo', '2026-01-10', 'ATIVO'),
('Bruno Lima', '11990000002', 'bruno.teste@example.com', 'Rua B, São Paulo', '2026-02-15', 'ATIVO'),
('Carla Mendes', '11990000003', 'carla.teste@example.com', 'Rua C, São Paulo', '2026-03-20', 'INATIVO');

INSERT INTO ingrediente (nome, unidade_medida, custo_unitario, fornecedor, data_atualizacao, status) VALUES
('Massa de pizza', 'unidade', 4.50, 'Fornecedor Alfa', '2026-10-01', 'ATIVO'),
('Molho de tomate', 'kg', 8.00, 'Fornecedor Beta', '2026-10-01', 'ATIVO'),
('Muçarela', 'kg', 32.00, 'Fornecedor Gama', '2026-10-01', 'ATIVO'),
('Calabresa', 'kg', 24.00, 'Fornecedor Delta', '2026-10-01', 'ATIVO'),
('Orégano', 'kg', 40.00, 'Fornecedor Épsilon', '2026-10-01', 'ATIVO'),
('Ingrediente descontinuado', 'kg', 10.00, 'Fornecedor Zeta', '2026-10-01', 'INATIVO');

INSERT INTO custo_fixo (descricao, valor_mensal, data_inicio, data_fim, status) VALUES
('Aluguel', 2500.00, '2026-01-01', NULL, 'ATIVO'),
('Energia e água', 900.00, '2026-01-01', NULL, 'ATIVO'),
('Manutenção antiga', 250.00, '2025-01-01', '2025-12-31', 'INATIVO');

INSERT INTO margem_lucro (descricao, percentual, data_inicio, data_fim, status) VALUES
('Margem padrão', 40.00, '2026-01-01', NULL, 'ATIVO'),
('Margem promocional antiga', 25.00, '2025-01-01', '2025-12-31', 'INATIVO');

INSERT INTO produto (nome, descricao, categoria, preco_venda, id_margem, status) VALUES
('Pizza de Calabresa', 'Pizza tradicional de calabresa', 'Pizza', 39.90, 1, 'ATIVO'),
('Pizza de Muçarela', 'Pizza tradicional de muçarela', 'Pizza', 35.90, 1, 'ATIVO'),
('Pizza Especial', 'Pizza especial da casa', 'Pizza', 49.90, 1, 'ATIVO'),
('Pizza Descontinuada', 'Produto fora do cardápio', 'Pizza', 29.90, 2, 'INATIVO');

INSERT INTO item_receita (id_produto, id_ingrediente, quantidade) VALUES
(1, 1, 1.000), (1, 2, 0.150), (1, 4, 0.200), (1, 5, 0.003),
(2, 1, 1.000), (2, 2, 0.150), (2, 3, 0.250), (2, 5, 0.003),
(3, 1, 1.000), (3, 2, 0.180), (3, 3, 0.200), (3, 4, 0.150);

INSERT INTO concorrente (nome, contato, endereco, observacoes) VALUES
('Pizzaria Sabor da Vila', 'contato fictício', 'Endereço fictício, São Paulo', 'Dados acadêmicos fictícios'),
('Pizzaria Forno Leste', 'contato fictício', 'Endereço fictício, São Paulo', 'Dados acadêmicos fictícios');

INSERT INTO pizza_concorrente
(id_produto, id_concorrente, preco_praticado, data_coleta, observacao) VALUES
(1, 1, 42.90, '2026-10-10', 'Preço de exemplo'),
(1, 2, 38.90, '2026-10-12', 'Preço de exemplo'),
(2, 1, 36.90, '2026-10-10', 'Preço de exemplo'),
(3, 2, 52.90, '2026-10-12', 'Preço de exemplo');

INSERT INTO venda (id_cliente, data_venda, observacao) VALUES
(1, '2026-10-15 19:30:00', 'Venda fictícia para teste'),
(2, '2026-10-16 20:10:00', 'Venda fictícia para teste'),
(1, '2026-10-20 18:45:00', 'Venda fictícia para teste');

INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 39.90), (1, 2, 1, 35.90),
(2, 3, 1, 49.90),
(3, 1, 1, 39.90), (3, 2, 2, 35.90);

INSERT INTO usuario_autorizado (nome, login, autorizado_precificacao, status) VALUES
('Administrador de teste', 'admin_teste', TRUE, 'ATIVO'),
('Operador de teste', 'operador_teste', FALSE, 'ATIVO');

-- ============================================================
-- 3. SELECTS COM JOIN
-- ============================================================

-- S01 - Listar pizzas com a margem associada.
SELECT p.id_produto, p.nome, p.preco_venda, m.descricao AS margem,
       m.percentual, m.status AS status_margem
FROM produto p
LEFT JOIN margem_lucro m ON m.id_margem = p.id_margem;

-- S02 - Receita de cada pizza e custo dos ingredientes.
SELECT p.nome AS pizza, i.nome AS ingrediente, ir.quantidade,
       i.unidade_medida, i.custo_unitario,
       ROUND(ir.quantidade * i.custo_unitario, 2) AS custo_ingrediente
FROM item_receita ir
JOIN produto p ON p.id_produto = ir.id_produto
JOIN ingrediente i ON i.id_ingrediente = ir.id_ingrediente
ORDER BY p.nome, i.nome;

-- S03 - Histórico de vendas com cliente, produto e valor do item.
SELECT v.id_venda, v.data_venda, c.nome AS cliente, p.nome AS pizza,
       iv.quantidade, iv.preco_unitario,
       ROUND(iv.quantidade * iv.preco_unitario, 2) AS subtotal
FROM venda v
JOIN cliente c ON c.id_cliente = v.id_cliente
JOIN item_venda iv ON iv.id_venda = v.id_venda
JOIN produto p ON p.id_produto = iv.id_produto
ORDER BY v.data_venda, v.id_venda;

-- S04 - Comparação dos preços com concorrentes.
SELECT p.nome AS pizza, co.nome AS concorrente, pc.preco_praticado,
       pc.data_coleta,
       ROUND(p.preco_venda - pc.preco_praticado, 2) AS diferenca_preco
FROM pizza_concorrente pc
JOIN produto p ON p.id_produto = pc.id_produto
JOIN concorrente co ON co.id_concorrente = pc.id_concorrente
ORDER BY p.nome, pc.data_coleta DESC;

-- ============================================================
-- 4. CÁLCULO DE CUSTO E PREÇO SUGERIDO
-- Observação: os custos fixos são rateados igualmente pelo número
-- de produtos ATIVOS com receita cadastrada. Para uso real, defina
-- um critério de rateio mais adequado (volume de vendas, horas etc.).
-- O percentual de margem é aplicado como acréscimo sobre o custo.
-- ============================================================

CREATE VIEW vw_custo_produto AS
SELECT p.id_produto,
       p.nome,
       p.preco_venda,
       p.status AS status_produto,
       COALESCE((
           SELECT SUM(ir.quantidade * i.custo_unitario)
           FROM item_receita ir
           JOIN ingrediente i ON i.id_ingrediente = ir.id_ingrediente
           WHERE ir.id_produto = p.id_produto
             AND i.status = 'ATIVO'
       ), 0) AS custo_ingredientes,
       COALESCE((
           SELECT SUM(cf.valor_mensal)
           FROM custo_fixo cf
           WHERE cf.status = 'ATIVO'
             AND cf.data_inicio <= CURRENT_DATE
             AND (cf.data_fim IS NULL OR cf.data_fim >= CURRENT_DATE)
       ), 0) AS total_custos_fixos,
       GREATEST((
           SELECT COUNT(DISTINCT ir2.id_produto)
           FROM item_receita ir2
           JOIN produto p2 ON p2.id_produto = ir2.id_produto
           WHERE p2.status = 'ATIVO'
       ), 1) AS quantidade_produtos_com_receita
FROM produto p;

CREATE VIEW vw_precificacao AS
SELECT cp.id_produto, cp.nome, cp.preco_venda, cp.status_produto,
       ROUND(cp.custo_ingredientes, 2) AS custo_ingredientes,
       ROUND(cp.total_custos_fixos / cp.quantidade_produtos_com_receita, 2) AS custo_fixo_rateado,
       ROUND(cp.custo_ingredientes +
             cp.total_custos_fixos / cp.quantidade_produtos_com_receita, 2) AS custo_total_estimado,
       m.percentual AS margem_percentual,
       m.status AS status_margem,
       ROUND((cp.custo_ingredientes +
             cp.total_custos_fixos / cp.quantidade_produtos_com_receita) *
             (1 + COALESCE(m.percentual, 0) / 100), 2) AS preco_sugerido,
       ROUND(cp.preco_venda -
             (cp.custo_ingredientes +
             cp.total_custos_fixos / cp.quantidade_produtos_com_receita), 2) AS diferenca_preco_custo
FROM vw_custo_produto cp
LEFT JOIN produto p ON p.id_produto = cp.id_produto
LEFT JOIN margem_lucro m ON m.id_margem = p.id_margem
  AND m.status = 'ATIVO'
  AND m.data_inicio <= CURRENT_DATE
  AND (m.data_fim IS NULL OR m.data_fim >= CURRENT_DATE);

-- ============================================================
-- 5. CONSULTAS GERENCIAIS
-- Cada consulta responde a uma pergunta de gestão. Como os problemas
-- e KPIs formais da primeira entrega não foram fornecidos, estes são
-- indicadores sugeridos e devem ser alinhados ao documento da turma.
-- ============================================================

-- G01 — Quais pizzas têm preço de venda menor ou igual ao custo total estimado?
-- Atende: P1 (identificar risco de vender sem cobrir os custos).
SELECT id_produto, nome, preco_venda, custo_total_estimado,
       diferenca_preco_custo
FROM vw_precificacao
WHERE status_produto = 'ATIVO'
  AND preco_venda <= custo_total_estimado
ORDER BY diferenca_preco_custo;

-- G02 — Qual é o preço sugerido para cada pizza considerando custos e margem ativa?
-- Atende: P1 (falta de sistema de precificação).
SELECT id_produto, nome, custo_ingredientes, custo_fixo_rateado,
       custo_total_estimado, margem_percentual, preco_venda, preco_sugerido
FROM vw_precificacao
WHERE status_produto = 'ATIVO'
ORDER BY nome;

-- G03 — Qual é a diferença entre o preço da pizzaria e o preço médio coletado dos concorrentes?
-- Atende: P2 (dificuldade de comparar preços de concorrentes).
SELECT p.id_produto, p.nome, p.preco_venda,
       ROUND(AVG(pc.preco_praticado), 2) AS preco_medio_concorrentes,
       ROUND(p.preco_venda - AVG(pc.preco_praticado), 2) AS diferenca_para_media
FROM produto p
JOIN pizza_concorrente pc ON pc.id_produto = p.id_produto
WHERE p.status = 'ATIVO'
GROUP BY p.id_produto, p.nome, p.preco_venda
ORDER BY diferenca_para_media;

-- G04 — Quais pizzas geraram maior faturamento no histórico de vendas?
