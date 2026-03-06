<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Todo List</title>
    <!-- Bootstrap CSS + icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-XxX" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            margin: 0;
            display: flex;
            flex-direction: column;
            color: white;
        }
        .header {
            padding: 1rem 2rem;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.18);
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 16px 0 rgba(31, 38, 135, 0.2);
        }
        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .contact-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 15px 0 rgba(31, 38, 135, 0.2);
        }
        .contact-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px 0 rgba(31, 38, 135, 0.3);
        }
        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }
        .content-box {
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 2rem;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }
        .todo-header { display:flex; align-items:center; justify-content:space-between; gap:1rem; }
        .todo-input { max-width:600px; margin: 0 auto 1rem auto; display:flex; gap:.5rem; }
        .task-item { display:flex; align-items:center; justify-content:space-between; gap:1rem; padding:.5rem 0; border-bottom:1px solid rgba(255,255,255,0.05); }
        .task-left { display:flex; align-items:center; gap:.75rem; }
        .task-title { font-size:1rem; color: #fff; }
        .task-title.completed { text-decoration: line-through; opacity: 0.7; }
        .icon-btn { background: transparent; border: none; color: white; cursor: pointer; }
        h2 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        @media (max-width: 768px) {
            .header {
                padding: 1rem;
                flex-direction: column;
                gap: 1rem;
            }
            .logo {
                font-size: 1.2rem;
            }
            .contact-btn {
                padding: 0.6rem 1.2rem;
                font-size: 0.9rem;
            }
            h2 {
                font-size: 2rem;
            }
            p {
                font-size: 1rem;
            }
            .content-box {
                padding: 1.5rem;
            }
        }
        </style>
</head>
<body>
<div class="header">
        <div class="logo">My Web App</div>
        <a href="contact.jsp" class="contact-btn">Contact Us</a>
</div>
<div class="container">
        <div class="content-box w-100" style="max-width:900px;">
                <div class="todo-header">
                        <div>
                                <h2 style="margin:0">Todo List</h2>
                                <div style="font-size:.9rem; opacity:.9">Server Time: <%= new java.util.Date() %></div>
                        </div>
                        <div>
                                <small style="opacity:.9">Connected to SQLite</small>
                        </div>
                </div>

                <div class="todo-input mt-3">
                        <input id="newTitle" class="form-control" placeholder="Add a new task and press Enter" aria-label="New task">
                        <button id="addBtn" class="btn btn-light">Add</button>
                </div>

                <div id="tasksList" class="mt-3 text-start" style="max-height:480px; overflow:auto;">
                        <!-- tasks will be injected here -->
                        <div id="loading" style="color:rgba(255,255,255,0.8)">Loading tasks…</div>
                </div>
                <div id="error" class="mt-2 text-danger" style="display:none"></div>
        </div>
</div>

<!-- Bootstrap JS (optional if needed for components) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-YYY" crossorigin="anonymous"></script>

<script>
const apiBase = 'api/tasks'; // relative to context path

function showError(msg) {
    const el = document.getElementById('error');
    if (!el) return;
    el.textContent = msg;
    el.style.display = msg ? 'block' : 'none';
}

async function loadTasks() {
        const list = document.getElementById('tasksList');
        const loadingEl = document.getElementById('loading');
        if (loadingEl) loadingEl.style.display = 'block';
    showError('');
    try {
        const res = await fetch(apiBase);
        if (!res.ok) throw new Error('Failed to load tasks: ' + res.status);
        const tasks = await res.json();
        renderTasks(tasks);
    } catch (e) {
        showError(e.message);
        list.innerHTML = '';
        } finally {
            const ld = document.getElementById('loading');
            if (ld) ld.style.display = 'none';
        }
}

function renderTasks(tasks) {
    const container = document.getElementById('tasksList');
    container.innerHTML = '';
    if (!tasks || tasks.length === 0) {
        container.innerHTML = '<div style="color:rgba(255,255,255,0.8)">No tasks yet. Add one above.</div>';
        return;
    }
    tasks.forEach(t => {
        const row = document.createElement('div');
        row.className = 'task-item';

        const left = document.createElement('div'); left.className = 'task-left';
        const cb = document.createElement('input'); cb.type = 'checkbox'; cb.checked = !!t.completed;
        cb.addEventListener('change', () => toggleCompleted(t.id, cb.checked));

        const title = document.createElement('span');
        title.className = 'task-title' + (t.completed ? ' completed' : '');
        title.textContent = t.title;
        title.title = 'Double-click to edit';
        title.addEventListener('dblclick', () => editTask(t.id, t.title));

        left.appendChild(cb); left.appendChild(title);

        const actions = document.createElement('div');
        // edit button
        const editBtn = document.createElement('button'); editBtn.className='icon-btn me-2'; editBtn.innerHTML = '<i class="bi bi-pencil"></i>';
        editBtn.title = 'Edit'; editBtn.addEventListener('click', () => editTask(t.id, t.title));
        // delete button
        const delBtn = document.createElement('button'); delBtn.className='icon-btn'; delBtn.innerHTML = '<i class="bi bi-trash"></i>';
        delBtn.title = 'Delete'; delBtn.addEventListener('click', () => deleteTask(t.id));

        actions.appendChild(editBtn); actions.appendChild(delBtn);

        row.appendChild(left); row.appendChild(actions);
        container.appendChild(row);
    });
}

async function addTask() {
    const input = document.getElementById('newTitle');
    const title = input.value && input.value.trim();
    if (!title) return;
    showError('');
    try {
        const addBtn = document.getElementById('addBtn');
        if (addBtn) addBtn.disabled = true;
        const res = await fetch(apiBase, { method: 'POST', headers: {'Content-Type':'application/json'}, body: JSON.stringify({ title: title, completed: false }) });
        if (!res.ok) throw new Error('Create failed: ' + res.status);
        input.value = '';
        await loadTasks();
        if (addBtn) addBtn.disabled = false;
    } catch (e) { showError(e.message); }
}

async function toggleCompleted(id, completed) {
    showError('');
    try {
        // Always fetch current task then send full object with updated completed flag
        const cbSelector = null; // placeholder
        const curRes = await fetch(apiBase + '/' + id);
        if (!curRes.ok) throw new Error('Unable to fetch task for update');
        const cur = await curRes.json();
        cur.completed = completed;
        // disable UI for this task while updating
        // (we cannot easily get the specific checkbox element here, so reload after update)
        const res = await fetch(apiBase + '/' + id, { method: 'PUT', headers: {'Content-Type':'application/json'}, body: JSON.stringify(cur) });
        if (!res.ok) throw new Error('Update failed: ' + res.status);
        await loadTasks();
    } catch (e) { showError(e.message); }
}

async function editTask(id, currentTitle) {
    const newTitle = prompt('Edit task title:', currentTitle);
    if (newTitle === null) return; // cancelled
    const trimmed = newTitle.trim();
    if (!trimmed) { alert('Title cannot be empty'); return; }
    showError('');
    try {
        // GET current to preserve completed flag
        const curRes = await fetch(apiBase + '/' + id);
        if (!curRes.ok) throw new Error('Unable to fetch task for update');
        const cur = await curRes.json();
        cur.title = trimmed;
        const res = await fetch(apiBase + '/' + id, { method: 'PUT', headers: {'Content-Type':'application/json'}, body: JSON.stringify(cur) });
        if (!res.ok) throw new Error('Update failed: ' + res.status);
        await loadTasks();
    } catch (e) { showError(e.message); }
}

async function deleteTask(id) {
    if (!confirm('Delete this task?')) return;
    showError('');
    try {
    const res = await fetch(apiBase + '/' + id, { method: 'DELETE' });
        if (!res.ok) throw new Error('Delete failed: ' + res.status);
        await loadTasks();
    } catch (e) { showError(e.message); }
}

document.addEventListener('DOMContentLoaded', () => {
    loadTasks();
    const addBtn = document.getElementById('addBtn');
    if (addBtn) addBtn.addEventListener('click', addTask);
    const newTitle = document.getElementById('newTitle');
    if (newTitle) newTitle.addEventListener('keydown', (e) => { if (e.key === 'Enter') addTask(); });
});
</script>
</body>
</html>