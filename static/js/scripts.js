$(function() {
    if (window.PIE) {
        $('#content article, #content header').each(function() {
            PIE.attach(this);
        });
    }
});