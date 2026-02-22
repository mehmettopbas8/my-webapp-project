<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us</title>
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
        .logo a {
            color: white;
            text-decoration: none;
        }
        .nav-btn {
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
        .nav-btn:hover {
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
        .contact-box {
            background: rgba(255, 255, 255, 0.1);
            padding: 2.5rem;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
            max-width: 600px;
            width: 100%;
        }
        h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            text-align: center;
        }
        .subtitle {
            text-align: center;
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            font-size: 1rem;
        }
        input[type="text"],
        input[type="email"],
        textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            font-size: 1rem;
            font-family: inherit;
            backdrop-filter: blur(10px);
            box-sizing: border-box;
        }
        input[type="text"]:focus,
        input[type="email"]:focus,
        textarea:focus {
            outline: none;
            border-color: rgba(255, 255, 255, 0.5);
            background: rgba(255, 255, 255, 0.15);
        }
        input::placeholder,
        textarea::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }
        textarea {
            resize: vertical;
            min-height: 120px;
        }
        .submit-btn {
            width: 100%;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 1rem;
            border-radius: 25px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 15px 0 rgba(31, 38, 135, 0.2);
        }
        .submit-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px 0 rgba(31, 38, 135, 0.3);
        }
        .submit-btn:active {
            transform: translateY(0);
        }
        .success-message {
            background: rgba(76, 175, 80, 0.3);
            border: 1px solid rgba(76, 175, 80, 0.5);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            text-align: center;
            display: none;
        }
        .success-message.show {
            display: block;
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
            .nav-btn {
                padding: 0.6rem 1.2rem;
                font-size: 0.9rem;
            }
            .container {
                padding: 1rem;
            }
            .contact-box {
                padding: 1.5rem;
            }
            h1 {
                font-size: 2rem;
            }
            .subtitle {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo"><a href="index.jsp">My Web App</a></div>
    <a href="index.jsp" class="nav-btn">Home</a>
</div>
<div class="container">
    <div class="contact-box">
        <h1>Contact Us</h1>
        <p class="subtitle">We'd love to hear from you. Send us a message and we'll respond as soon as possible.</p>
        
        <div class="success-message" id="successMessage">
            Thank you for your message! We'll get back to you soon.
        </div>
        
        <form id="contactForm" method="post" action="contact.jsp">
            <div class="form-group">
                <label for="name">Name *</label>
                <input type="text" id="name" name="name" placeholder="Your name" required>
            </div>
            
            <div class="form-group">
                <label for="email">Email *</label>
                <input type="email" id="email" name="email" placeholder="your.email@example.com" required>
            </div>
            
            <div class="form-group">
                <label for="subject">Subject *</label>
                <input type="text" id="subject" name="subject" placeholder="What is this regarding?" required>
            </div>
            
            <div class="form-group">
                <label for="message">Message *</label>
                <textarea id="message" name="message" placeholder="Your message here..." required></textarea>
            </div>
            
            <button type="submit" class="submit-btn">Send Message</button>
        </form>
    </div>
</div>

<script>
    // Handle form submission
    document.getElementById('contactForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Get form values
        const name = document.getElementById('name').value;
        const email = document.getElementById('email').value;
        const subject = document.getElementById('subject').value;
        const message = document.getElementById('message').value;
        
        // Basic validation
        if (name && email && subject && message) {
            // Show success message
            document.getElementById('successMessage').classList.add('show');
            
            // Reset form
            this.reset();
            
            // Scroll to top to show success message
            window.scrollTo({ top: 0, behavior: 'smooth' });
            
            // Hide success message after 5 seconds
            setTimeout(function() {
                document.getElementById('successMessage').classList.remove('show');
            }, 5000);
            
            // In a real application, you would send this data to a server
            console.log('Form submitted:', { name, email, subject, message });
        }
    });
</script>
</body>
</html>

