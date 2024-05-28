from django.shortcuts import render

from django.shortcuts import render
from .models import Resume, Post, Skill, Project, Category



def home(request):
    resumes = Resume.objects.all()
    posts = Post.objects.all()
    skills = Skill.objects.all()
    latest_posts = Post.objects.all().order_by('-published_at')[:3]
    projects = Project.objects.all()
    categories = Category.objects.all()
    
    context = {
        'categories':categories,
        'resumes': resumes,
        'posts': latest_posts,
        'skills': skills,
        'projects': projects,
    }
    
    return render(request, 'monapp/index.html', context)


from django.shortcuts import render, get_object_or_404
from .models import Post


from django.shortcuts import render, get_object_or_404

def post_detail(request, slug):
    # Récupérer le projet basé sur le slug
    posts = get_object_or_404(Post, slug=slug)
    return render(request, 'monapp/single.html', {'posts': posts})
