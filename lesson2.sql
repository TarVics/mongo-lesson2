// # mongo-lesson2

// 1) Знайти всіх дітей в яких середня оцінка 4.2
db.students.find({ avgScore: 4.2 })
// 2) Знайди всіх дітей з 1 класу
db.students.find({ class: 1 })
// 3) Знайти всіх дітей які вивчають фізику
db.students.find({ lessons: 'physics' })
// 4) Знайти всіх дітей, батьки яких працюють в науці (scientist)
db.students.find({ 'parents.profession': 'scientist' })
// 5) Знайти дітей, в яких середня оцінка більша за 4
db.students.find({ avgScore: { $gt: 4 } })
// 6) Знайти найкращого учня
db.students.find().sort({ avgScore: -1 }).limit(1)
// 7) Знайти найгіршого учня
db.students.find().sort({ avgScore: 1 }).limit(1)
// 8) Знайти топ 3 учнів
db.students.find().sort({ avgScore: -1 }).limit(3)
// 9) Знайти середній бал по школі
db.students.aggregate([
    { $group: { _id: 1, avgScore: { $avg: '$avgScore'} } },
    { $project: { _id: 0 } }
])
// 10) Знайти середній бал дітей які вивчають математику або фізику
db.students.aggregate([
    { $match: { lessons: { $in: ['mathematics', 'physics'] } } },
    { $group: { _id: 1, avgScore: { $avg: '$avgScore'} } },
    { $project: { _id: 0 } }
])
// 11) Знайти середній бал по 2 класі
db.students.aggregate([
    { $match: { class: 2 } },
    { $group: { _id: '$class', avgScore: { $avg: '$avgScore'} } },
    { $project: { _id: 0 } }
])
// 12) Знайти дітей з не повною сім'єю
db.students.find({ $or: [ { parents: null}, { parents: { $size: 1 } } ] })
// 13) Знайти батьків які не працюють
db.students.aggregate([
    { $unwind: '$parents' },
    { $match: { 'parents.profession': null } },
    { $project: {
        gender: '$parents.gender',
        name: '$parents.name',
        profession: '$parents.profession'
    }}
])
// 14) Вигнати дітей, які мають середній бал менше ніж 2.5
db.students.deleteMany({ avgScore: { $lt: 2.5 } })
// 15) Дітям, батьки яких працюють в освіті (teacher) поставити 5
db.students.updateMany({ 'parents.profession': 'teacher' }, { $set: { avgScore: 5 } })
// 16) Знайти дітей які вчаться в початковій школі (до 5 класу) і вивчають фізику ( physics )
db.students.find({ class: { $lt: 5 } })
// 17) Знайти найуспішніший клас
db.students.aggregate([
    { $group: { _id: '$class', avgScore: { $avg: '$avgScore'} } },
    { $project: { _id: 0, class: '$_id', avgScore: 1 } },
    { $sort: { avgScore: -1 } },
    { $limit: 1 }
])
// ********** Батьків, що не працюють, влаштувати офіціантами (підказка: гуглимо "arrayFilters")
db.students.updateMany(
    { $and: [ { parents: { $exists: 1 } }, { 'parents.profession': null } ] },
    { $set: { 'parents.$[parent].profession': 'waiter' } },
    { arrayFilters: [ { 'parent.profession': null } ] }
)

