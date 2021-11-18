char a[] = "abcdefg";
char b[5];

int main() {
    for(int i = 0; i < 4; i++) {
        b[i] = a[4-i];
    }
    b[4] = 0;
    return 0;
}