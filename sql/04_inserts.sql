-- ============================================================
-- SIMULADOR ENEM — 04_inserts.sql
-- População das tabelas com dados válidos
-- ============================================================

-- ============================================================
-- PERFIS
-- ============================================================
INSERT INTO public.perfis (id, auth_id, nome_completo, papel) VALUES
  ('a1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001',
   'Augusto Carlos Eduardo Pires', 'admin_global'),
  ('a1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
   'Débora Jaqueline Monteiro', 'admin_escolar'),
  ('a1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
   'Flávia Isabella Isis Mendes', 'admin_escolar'),
  ('a1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
   'Cauã Bruno da Silva', 'aluno'),
  ('a1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000005',
   'Nicole Sônia Drumond', 'aluno'),
  ('a1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000006',
   'Emanuelly Stefany Gabriela Araújo', 'aluno'),
  ('a1000000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000007',
   'Milena Rebeca Carolina Bernardes', 'aluno'),
  ('a1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000008',
   'Juan Ricardo da Conceição', 'aluno'),
  ('a1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000009',
   'Patrícia Agatha Duarte', 'aluno'),
  ('a1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000010',
   'Rafael Nelson Henrique Figueiredo', 'aluno'),
  ('a1000000-0000-0000-0000-000000000011', 'b1000000-0000-0000-0000-000000000011',
   'Brenda Lívia Vitória Silveira', 'aluno'),
  ('a1000000-0000-0000-0000-000000000012', 'b1000000-0000-0000-0000-000000000012',
   'Joaquim Bernardo Campos', 'aluno');

-- ============================================================
-- ESCOLAS
-- ============================================================
INSERT INTO public.escolas (id, nome, cnpj, admin_id) VALUES
  ('c1000000-0000-0000-0000-000000000001',
   'Colégio Estadual Dom Pedro II', '12345678000199',
   'a1000000-0000-0000-0000-000000000002'),
  ('c1000000-0000-0000-0000-000000000002',
   'Instituto Federal do Paraná',   '98765432000188',
   'a1000000-0000-0000-0000-000000000003');

-- ============================================================
-- MATRICULAS
-- ============================================================
INSERT INTO public.matriculas (aluno_id, escola_id) VALUES
  ('a1000000-0000-0000-0000-000000000004', 'c1000000-0000-0000-0000-000000000001'),
  ('a1000000-0000-0000-0000-000000000005', 'c1000000-0000-0000-0000-000000000001'),
  ('a1000000-0000-0000-0000-000000000006', 'c1000000-0000-0000-0000-000000000001'),
  ('a1000000-0000-0000-0000-000000000007', 'c1000000-0000-0000-0000-000000000001'),
  ('a1000000-0000-0000-0000-000000000008', 'c1000000-0000-0000-0000-000000000001'),
  ('a1000000-0000-0000-0000-000000000009', 'c1000000-0000-0000-0000-000000000002'),
  ('a1000000-0000-0000-0000-000000000010', 'c1000000-0000-0000-0000-000000000002'),
  ('a1000000-0000-0000-0000-000000000011', 'c1000000-0000-0000-0000-000000000002'),
  ('a1000000-0000-0000-0000-000000000004', 'c1000000-0000-0000-0000-000000000002');

-- ============================================================
-- QUESTOES
-- ============================================================
INSERT INTO public.questoes (id, numero, enunciado, alternativas) VALUES
  ('d1000000-0000-0000-0000-000000000001', 1,
   '{"texto": "Qual é o resultado de 2 + 2?"}',
   '[{"id":1,"texto":"3"},{"id":2,"texto":"4"},{"id":3,"texto":"5"},{"id":4,"texto":"6"}]'),
  ('d1000000-0000-0000-0000-000000000002', 2,
   '{"texto": "Quem escreveu Dom Casmurro?"}',
   '[{"id":1,"texto":"José de Alencar"},{"id":2,"texto":"Machado de Assis"},{"id":3,"texto":"Eça de Queirós"},{"id":4,"texto":"Lima Barreto"}]'),
  ('d1000000-0000-0000-0000-000000000045', 45,
   '{"texto": "Sobre a Lei da Gravitação Universal de Newton, se dobrarmos a distância entre dois corpos, a força gravitacional entre eles será:"}',
   '[{"id":1,"texto":"Igual"},{"id":2,"texto":"Dobrada"},{"id":3,"texto":"Reduzida à metade"},{"id":4,"texto":"Reduzida a um quarto"}]');

-- ============================================================
-- SESSOES_SIMULADO
--
-- QUERY 09 (auditoria): sessão e8 tem total_questoes=5 mas
--   só terá 3 respostas → inconsistência proposital
--
-- QUERY 10 (hall da fama): Cauã acumula 102 questões em
--   sessões concluídas (e1 + e9 + e10) com 68 acertos
--   Nicole acumula 100 questões com 60 acertos
-- ============================================================
INSERT INTO public.sessoes_simulado
  (id, aluno_id, status, iniciado_em, finalizado_em, total_questoes, total_acertos)
VALUES
  -- Sessões normais
  ('e1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000004',
   'concluida', NOW()-INTERVAL '10 days', NOW()-INTERVAL '10 days'+INTERVAL '40 min', 3, 2),

  ('e1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000005',
   'concluida', NOW()-INTERVAL '9 days',  NOW()-INTERVAL '9 days' +INTERVAL '35 min', 2, 1),

  ('e1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000006',
   'em_andamento', NOW()-INTERVAL '1 hour', NULL, 1, 0),

  ('e1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000007',
   'concluida', NOW()-INTERVAL '8 days',  NOW()-INTERVAL '8 days' +INTERVAL '50 min', 2, 2),

  ('e1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000008',
   'concluida', NOW()-INTERVAL '7 days',  NOW()-INTERVAL '7 days' +INTERVAL '45 min', 2, 1),

  ('e1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000010',
   'concluida', NOW()-INTERVAL '6 days',  NOW()-INTERVAL '6 days' +INTERVAL '30 min', 1, 1),

  ('e1000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000011',
   'concluida', NOW()-INTERVAL '5 days',  NOW()-INTERVAL '5 days' +INTERVAL '60 min', 3, 1),

  -- Sessão com inconsistência para query 09:
  -- total_questoes=5 e total_acertos=4, mas só 3 respostas serão inseridas
  ('e1000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000009',
   'concluida', NOW()-INTERVAL '4 days',  NOW()-INTERVAL '4 days' +INTERVAL '55 min', 5, 4),

  -- Sessões extras para Cauã atingir 102 questões (query 10)
  -- e1=3 questões + e9=50 + e10=49 = 102 total, 68 acertos
  ('e1000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000004',
   'concluida', NOW()-INTERVAL '3 days',  NOW()-INTERVAL '3 days' +INTERVAL '90 min', 50, 34),

  ('e1000000-0000-0000-0000-000000000010', 'a1000000-0000-0000-0000-000000000004',
   'concluida', NOW()-INTERVAL '2 days',  NOW()-INTERVAL '2 days' +INTERVAL '85 min', 49, 32),

  -- Sessões extras para Nicole atingir 100 questões
  -- e2=2 questões + e11=98 = 100 total, 60 acertos
  ('e1000000-0000-0000-0000-000000000011', 'a1000000-0000-0000-0000-000000000005',
   'concluida', NOW()-INTERVAL '2 days',  NOW()-INTERVAL '2 days' +INTERVAL '80 min', 98, 59);

-- ============================================================
-- RESPOSTAS
-- Sessões e9, e10, e11 têm totalizadores direto na sessão;
-- inserimos apenas as respostas das sessões com questões reais
-- ============================================================
INSERT INTO public.respostas (sessao_id, questao_id, alternativa_escolhida, esta_correta) VALUES
  -- Cauã (e1): acertou q1 e q2, errou q45
  ('e1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000001', 2, true),
  ('e1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000002', 2, true),
  ('e1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000045', 3, false),

  -- Nicole (e2): acertou q1, errou q45
  ('e1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000001', 2, true),
  ('e1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000045', 1, false),

  -- Emanuelly (e3, em andamento): errou q45
  ('e1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000045', 2, false),

  -- Milena (e4): acertou q1 e q2
  ('e1000000-0000-0000-0000-000000000004', 'd1000000-0000-0000-0000-000000000001', 2, true),
  ('e1000000-0000-0000-0000-000000000004', 'd1000000-0000-0000-0000-000000000002', 2, true),

  -- Juan (e5): acertou q1, errou q45
  ('e1000000-0000-0000-0000-000000000005', 'd1000000-0000-0000-0000-000000000001', 2, true),
  ('e1000000-0000-0000-0000-000000000005', 'd1000000-0000-0000-0000-000000000045', 1, false),

  -- Rafael (e6): acertou q2
  ('e1000000-0000-0000-0000-000000000006', 'd1000000-0000-0000-0000-000000000002', 2, true),

  -- Brenda (e7): acertou q1, errou q2 e q45
  ('e1000000-0000-0000-0000-000000000007', 'd1000000-0000-0000-0000-000000000001', 2, true),
  ('e1000000-0000-0000-0000-000000000007', 'd1000000-0000-0000-0000-000000000002', 1, false),
  ('e1000000-0000-0000-0000-000000000007', 'd1000000-0000-0000-0000-000000000045', 3, false),

  -- Patrícia (e8): só 3 respostas, mas sessão diz 5 → inconsistência para query 09
  ('e1000000-0000-0000-0000-000000000008', 'd1000000-0000-0000-0000-000000000001', 2, true),
  ('e1000000-0000-0000-0000-000000000008', 'd1000000-0000-0000-0000-000000000002', 2, true),
  ('e1000000-0000-0000-0000-000000000008', 'd1000000-0000-0000-0000-000000000045', 3, false);
