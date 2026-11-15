'use strict';
const menu = document.querySelector('.menu');
const nav = document.querySelector('#nav');
function closeMenu() {
  nav.classList.remove('open');
  menu.setAttribute('aria-expanded', 'false');
  menu.setAttribute('aria-label', 'Open navigation');
}
menu.addEventListener('click', () => {
  const expanded = menu.getAttribute('aria-expanded') !== 'true';
  nav.classList.toggle('open', expanded);
  menu.setAttribute('aria-expanded', String(expanded));
  menu.setAttribute('aria-label', expanded ? 'Close navigation' : 'Open navigation');
});
nav.querySelectorAll('a').forEach(link => link.addEventListener('click', closeMenu));
document.addEventListener('keydown', event => {
  if (event.key === 'Escape' && nav.classList.contains('open')) {
    closeMenu();
    menu.focus();
  }
});
document.addEventListener('click', event => {
  if (!event.target.closest('.header')) closeMenu();
});
if ('IntersectionObserver' in window) {
  const sections = document.querySelectorAll('section[id]');
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        nav.querySelectorAll('a').forEach(link => {
          const active = link.getAttribute('href') === '#' + entry.target.id;
          link.classList.toggle('active', active);
          if (active) link.setAttribute('aria-current', 'location');
          else link.removeAttribute('aria-current');
        });
      }
    });
  }, { rootMargin: '-15% 0px -60% 0px', threshold: 0 });
  sections.forEach(section => observer.observe(section));
}
document.querySelector('#year').textContent = String(new Date().getFullYear());
const email = 'rgordz460@outlook.com';
const status = document.querySelector('#copy-status');
document.querySelector('#copy-email').addEventListener('click', async () => {
  let copied = false;
  try {
    if (navigator.clipboard && window.isSecureContext) {
      await navigator.clipboard.writeText(email);
      copied = true;
    }
  } catch (_) { /* Try the local-file fallback. */ }
  if (!copied) {
    const field = document.createElement('textarea');
    field.value = email;
    field.setAttribute('readonly', '');
    field.setAttribute('aria-label', 'Email address to copy');
    field.style.position = 'fixed';
    field.style.left = '-9999px';
    document.body.append(field);
    field.select();
    try { copied = document.execCommand('copy'); } catch (_) { copied = false; }
    field.remove();
    document.querySelector('#copy-email').focus();
  }
  status.textContent = copied ? 'Email address copied.' : 'Please select and copy the address above: ' + email;
});
