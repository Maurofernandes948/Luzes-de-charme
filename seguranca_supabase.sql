-- ==========================================
-- SCRIPT SQL DE SEGURANÇA (SUPABASE RLS)
-- ==========================================
-- Este script define quem pode ler e editar o seu banco de dados.
-- Copie e cole este código no painel "SQL Editor" do seu Supabase.

-- 1. Ativar a segurança a nível de linha (Row Level Security) em todas as tabelas
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE gallery ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- ==========================================
-- REGRAS PARA PRODUTOS E GALERIA (PORTFÓLIO)
-- ==========================================
-- Todos os visitantes podem VER (SELECT) os produtos e o portfólio
CREATE POLICY "Permitir visualização pública de produtos" 
ON products FOR SELECT 
USING (true);

CREATE POLICY "Permitir visualização pública da galeria" 
ON gallery FOR SELECT 
USING (true);

-- APENAS ADMINS podem INSERIR, ATUALIZAR ou DELETAR
CREATE POLICY "Apenas administradores podem modificar produtos" 
ON products FOR ALL 
USING (auth.jwt() -> 'user_metadata' ->> 'role' = 'admin');

CREATE POLICY "Apenas administradores podem modificar galeria" 
ON gallery FOR ALL 
USING (auth.jwt() -> 'user_metadata' ->> 'role' = 'admin');

-- ==========================================
-- REGRAS PARA ENCOMENDAS (ORDERS) E DADOS PRIVADOS
-- ==========================================
-- Apenas o administrador pode ver COMPLETAMENTE a lista de encomendas feitas
CREATE POLICY "Apenas administradores podem ver todas as encomendas" 
ON orders FOR SELECT 
USING (auth.jwt() -> 'user_metadata' ->> 'role' = 'admin');

-- Clientes só podem ver as suas PRÓPRIAS encomendas
CREATE POLICY "Clientes veem apenas as suas encomendas" 
ON orders FOR SELECT 
USING (auth.uid() = user_id);

-- Clientes podem criar uma encomenda
CREATE POLICY "Clientes podem criar encomendas" 
ON orders FOR INSERT 
WITH CHECK (auth.uid() = user_id);

-- ==========================================
-- REGRAS PARA A TABELA DE UTILIZADORES (USERS)
-- ==========================================
-- Admin pode ver todos os registos
CREATE POLICY "Apenas administradores podem ver todos utilizadores"
ON users FOR SELECT
USING (auth.jwt() -> 'user_metadata' ->> 'role' = 'admin');

-- Utilizador só tem acesso a ler e alterar os seus próprios dados de perfil
CREATE POLICY "Utilizadores gerem os seus próprios metadados"
ON users FOR ALL
USING (auth.uid() = id);
